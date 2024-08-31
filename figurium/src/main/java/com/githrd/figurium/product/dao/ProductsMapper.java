package com.githrd.figurium.product.dao;

import com.githrd.figurium.product.dto.ProductDto;
import com.githrd.figurium.product.vo.CartsVo;
import com.githrd.figurium.product.vo.ProductsVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface ProductsMapper {

    ProductsVo selectOneGetName(int productId);
}
