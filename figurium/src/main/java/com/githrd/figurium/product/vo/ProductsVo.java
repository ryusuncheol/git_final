package com.githrd.figurium.product.vo;

import lombok.Data;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@Data
@Alias("products")
public class ProductsVo {

    // 상품 테이블 (Create table products)
    int id;         // primary key
    int categoryId;
    String name;
    int price;
    int quantity;
    String imageUrl;
    Date createTime;
    Date added_time;

}
