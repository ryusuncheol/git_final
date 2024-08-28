package com.githrd.figurium.order.controller;

import com.githrd.figurium.product.entity.Products;
import com.githrd.figurium.product.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
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
        model.addAttribute("cartsList", cartsList);

        return "order/orderForm";
    }

    // inicis 결제 요청 처리하기
    @RequestMapping("order/inicisPay.do")
    @ResponseBody
    public String inicisPay() {

        return "";
    }




}
