package com.githrd.figurium.order.controller;

import com.githrd.figurium.order.dto.PaymentRequest;
import com.githrd.figurium.product.entity.Products;
import com.githrd.figurium.product.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class ShopingOrderController {

    private final ProductRepository productRepository;

    @Autowired
    public ShopingOrderController(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }


    @GetMapping("order/orderForm.do")
    public String orderForm(Model model) {

        // 지훈이형 Product DB 아무거나 던져보기
        Pageable pageable = PageRequest.of(0, 2);
        List<Products> cartsList = productRepository.findBuyProductsTwo(pageable);

        // JSP에서 계산 이뤄지게 하는 방식은 권장되지 않아서 서버딴에서 결제 처리
        int totalPrice = 0;

        for(Products products:cartsList) {
            totalPrice += products.getPrice() * products.getQuantity();
        }

        model.addAttribute("cartsList", cartsList);
        model.addAttribute("totalPrice", totalPrice);
        return "order/orderForm";
    }

    // inicis 결제 요청 처리하기 (PaymentRequest => DTO로 사용)
    @RequestMapping("order/inicisPay.do")
    @ResponseBody
    public String inicisPay(@RequestBody PaymentRequest paymentRequest) {



        return "";
    }




}
