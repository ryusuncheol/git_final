package com.githrd.figurium.order.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Alias("myOrders")
public class MyOrderVo {

    private int id;
    private String paymentType;
    private int userId;
    private Date createdAt;

    private int price;
    private int quantity;
    private String name;

    private String customerPhone;
    private String email;
    private String recipientName;
    private String phone;

    private String address;
    private String deliveryRequest;

    private String productName;
    private String imageUrl;
    private int productCount;


}
