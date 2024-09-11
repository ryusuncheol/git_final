package com.githrd.figurium.order.service;

import com.githrd.figurium.exception.customException.OutofStockException;
import com.githrd.figurium.order.dao.CustomersMapper;
import com.githrd.figurium.order.dao.OrderItemsMapper;
import com.githrd.figurium.order.dao.OrderMapper;
import com.githrd.figurium.order.dao.ShippingAddressesMapper;
import com.githrd.figurium.order.vo.Customers;
import com.githrd.figurium.order.vo.MyOrderVo;
import com.githrd.figurium.order.vo.OrderItems;
import com.githrd.figurium.order.vo.ShippingAddresses;
import com.githrd.figurium.product.dao.CartsMapper;
import com.githrd.figurium.product.dao.ProductsMapper;
import com.githrd.figurium.product.vo.CartsVo;
import com.githrd.figurium.product.vo.ProductsVo;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@Service
@RequiredArgsConstructor
@Slf4j
public class OrderServiceImpl implements OrderService {

    private final ProductsMapper productsMapper;
    private final CartsMapper cartsMapper;
    private final OrderMapper orderMapper;
    private final CustomersMapper customersMapper;
    private final ShippingAddressesMapper shippingAddressesMapper;
    private final OrderItemsMapper orderItemsMapper;
    private final HttpSession session;
    private final Lock lock = new ReentrantLock();


    // 주문창 가져오기
    @Override
    public List<CartsVo> updateCartQuantities(List<Integer> cartQuantities, int loginUserId, List<Integer> productId) {

        // 카드에 담겨있는 상품 가져오기
        List<CartsVo> cartsList = cartsMapper.checksCartItemList(loginUserId,productId);

        // 기존 수량 체크
        for (int i = 0; i < cartsList.size(); i++) {

            CartsVo cartsVo = cartsList.get(i);
            int existingQuantity = cartsVo.getQuantity();
            int newQuantity = cartQuantities.get(i);

            if (existingQuantity != newQuantity) {
                cartsVo.setQuantity(newQuantity); // 새로운 수량으로 업데이트
                // 수량을 가져와서 수량이 변경되었다면, 변경된 수량 반영
                int res = cartsMapper.updateCartQuantity(cartsVo);
            }
        }

        return cartsList;
    }


    public int calculateTotalPrice(List<CartsVo> cartsList) {
        // JSP에서 계산 이뤄지게 하는 방식은 권장되지 않아서 서버딴에서 결제 처리
        int totalPrice = 0;

        for(CartsVo products:cartsList) {
            totalPrice += products.getPrice() * products.getQuantity();
        }

        return totalPrice;
    }

    /**
     *  사용자 주문 내역 조회
     */
    @Override
    @Transactional
    public List<MyOrderVo> selectListByUserId(int userId) {
        return orderMapper.selectListByUserId(userId);
    }

    /**
     *  결제 전, 상품 재고 확인
     */
    @Override
    @Transactional
    public String checkProductStock(List<Integer> productIds, List<Integer> itemQuantities) {

        for(int i = 0; i < productIds.toArray().length; i++) {

            int productId = productIds.get(i); // 재고 상품 정보
            int itemQuantity = itemQuantities.get(i); // 재고 상품 갯수


            // ProductsVo에 담아서 재고 있는지 체크
            ProductsVo productsVo = productsMapper.selectOneCheckProduct(productId, itemQuantity);
            int itemQuantityCheck = productsVo.getQuantity();

            // 남아있는 재고 <= 주문재고
            if((Integer) itemQuantityCheck == null || itemQuantityCheck-itemQuantity<0) {
                return "error";
            }
        }

        return "success";
    }

    /**
     *  order정보 저장하기
     */
    @Override
    @Transactional
    public int insertOrder(int price, String paymentType, Integer userId, String merchantUid) {

        // 주문자 정보 insert
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("price",price);
        map.put("paymentType",paymentType);
        map.put("userId", userId);
        map.put("merchantUid", merchantUid);

        if (paymentType.equals("vbank")) {
            map.put("status","입금대기");
        }else {
            map.put("status","준비중");
        }

        return orderMapper.insertOrders(map);
    }


    /**
     *  재고 synchronized 동기화 영역
     */
//    @Override
//    @Transactional
//    public synchronized int updateProductQuantity(int productId, int itemQuantity) {
//        return productsMapper.updateProductQuantity(productId, itemQuantity);
//    }


    /**
     *  Lock를 이용한 동기화 처리
     */
    @Override
    @Transactional
    public int updateProductQuantity(int productId, int itemQuantity) {
        lock.lock();
        try {
            return productsMapper.updateProductQuantity(productId, itemQuantity);
        } finally {
            lock.unlock();
        }
    }


    /**
     *  장바구니 상품 삭제, 구매 상품 정보 저장
     */
    @Override
    @Transactional
    public int updateProductInfo(List<Integer> productIds, List<Integer> itemPrices,
                               List<Integer> itemQuantities, int loginUserId) {

        int orderId = orderMapper.selectOneLast().getId();

        // 반복문을 통해서 구매한 상품 장바구니 삭제, orderItems로 추가
        for(int i = 0; i < productIds.toArray().length; i++) {

            OrderItems orderItems = new OrderItems();
            orderItems.setOrderId(orderId);

            int productId = productIds.get(i);
            int itemPrice = itemPrices.get(i);
            int itemQuantity = itemQuantities.get(i);

            // 각 값을 저장
            orderItems.setProductId(productId);
            orderItems.setItemPrice(itemPrice);
            orderItems.setItemQuantity(itemQuantity);

            // 장바구니에 입력되어 있는 정보 중 구매한 상품 전부 삭제
            cartsMapper.deleteCartProduct(productId, loginUserId);

            orderItemsMapper.insertOrderItems(orderItems);  // 장바구니 -> orderItems 추가

            // 처음에 재고 확인 후 시간차 주문공격 체크
            ProductsVo productsVo = productsMapper.selectOneCheckProduct(productId, itemQuantity);
            int itemQuantityCheck = productsVo.getQuantity();
            // 상품 정보에 재고 업데이트
            // TODO 귀여미 Exception 처리
            if(itemQuantityCheck-itemQuantity<0) {
                log.error("There is insufficient stock due to someone else's purchase.: {}", "재고수량부족");
                throw new OutofStockException("Insufficient stock: 재고가 부족합니다.");
            }

            int res = updateProductQuantity(productId, itemQuantity);
        }

        return orderId;
    }

    /**
     *  주문자 정보 저장
     */
    @Transactional
    @Override
    public int insertCustomer(int orderId, String name, String phone, String email) {

        Customers customers = new Customers();

        customers.setOrderId(orderId);
        customers.setName(name);
        customers.setPhone(phone);
        customers.setEmail(email);

        return customersMapper.insertCustomers(customers);
    }

    /**
     *  배송지 정보 저장
     */
    @Transactional
    @Override
    public int insertShippingAddresses(int orderId, String recipientName, String shippingPhone,
                                      String address, String deliveryRequest) {

        ShippingAddresses shippingAddresses = new ShippingAddresses();

        shippingAddresses.setOrderId(orderId);
        shippingAddresses.setRecipientName(recipientName);
        shippingAddresses.setShippingPhone(shippingPhone);
        shippingAddresses.setAddress(address);
        shippingAddresses.setDeliveryRequest(deliveryRequest);

        return shippingAddressesMapper.insertShippingAddresses(shippingAddresses);
    }




}
