package com.githrd.figurium.product.service;

import com.githrd.figurium.exception.customException.ProductNotFoundException;
import com.githrd.figurium.product.dao.CartsMapper;
import com.githrd.figurium.product.dao.ProductsMapper;
import com.githrd.figurium.product.entity.Products;
import com.githrd.figurium.product.repository.ProductRepository;
import com.githrd.figurium.product.vo.ProductsVo;
import com.githrd.figurium.common.s3.S3ImageService;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service

public class ProductsService {

    private final ProductRepository productRepository;
    private final S3ImageService s3ImageService;
    private final ProductsMapper productsMapper;
    private final CartsMapper cartsMapper;



    @Autowired
    ProductsService(ProductRepository productRepository, S3ImageService s3ImageService, ProductsMapper productsMapper, CartsMapper cartsMapper) {
        this.productRepository = productRepository;
        this.s3ImageService = s3ImageService;
        this.productsMapper = productsMapper;
        this.cartsMapper = cartsMapper;
    }



    public Products getProductById(int id) {

        Optional<Products> productOptional = Optional.ofNullable(productRepository.findById(id));

        if (productOptional.isPresent()) {
            return productOptional.get();
        } else {
            throw new ProductNotFoundException("해당 상품이 없거나 삭제 되었습니다.");
        }

        //return productRepository.findById(id);
    }


    @Transactional
    public String imageSave(ProductsVo products, MultipartFile productImage) {

        // s3에 해당 이미지 업로드 후  set하고 db에 저장하기.
        if(!productImage.isEmpty()) {
            String profileImgUrl = s3ImageService.upload(productImage);
            products.setImageUrl(profileImgUrl);
        }else{
            products.setImageUrl("/images/noImage1.png");
            }
            int result = productsMapper.productInsert(products);
            if(result > 0) {
                return "/";
            }


        return "";
    }

    // 업로드된 상품 이미지 수정
    @Transactional
    public int updateProductsImage(ProductsVo products, MultipartFile productImage) {

        // s3에서 상품의 이미지 제거.
        s3ImageService.deleteImageFromS3(products.getImageUrl());
        // s3에 수정할 이미지 업로드 후 상품에 이미지 기재하기.
        products.setImageUrl(s3ImageService.upload(productImage));

        return productsMapper.productUpdate(products);
    }


    public int productSave(ProductsVo products) {
        return productsMapper.productInsert(products);
    }


    // 상품 카테고리 리스트의 동적 쿼리
    public List<ProductsVo> categoriesList(Map<String,Object> params ,int page, int pageSize){
        return productsMapper.categoriesList(params);
    }
    // 상품 카테고리의 페이징 처리를 위한 갯수 가져오기
    public int categoriesProductsCount(Map<String,Object> params){
        return productsMapper.categoriesProductsCount(params);
    }
    // 검색 상품의 동적쿼리
    public List<ProductsVo> searchProductsList(Map<String,Object> params, int page, int pageSize){
        return productsMapper.searchProductsList(params);
    }
    // 검색 상품의 페이지 처리를 위한 갯수
    public int searchProductCount(Map<String, Object> params) {
        return productsMapper.searchProductsCount(params);
    }

    // 검색 상품의 히스토리 저장
    public int searchProductsNameHistory(String search){

        // 검색어가 없거나 빈 문자열만 입력시 저장X
        if (search == null || search.trim().isEmpty()) {
            return -1;
        }

        // 해당 상품을 검색된 상품이 존재하는지 확인
        List<ProductsVo> searchProducts = productsMapper.selectSearchProductsList(search);
        if (searchProducts == null || searchProducts.isEmpty()) {
            return 0;
        }

        // 검증 통과 시 DB에 검색어를 저장 후 1을 반환
        return productsMapper.searchProductsNameHistory(search);
    }

    // 검색 상품의 순위별 조회
    public List<String> searchHistory(){
       return productsMapper.searchHistory();
    }


    public List<ProductsVo> getNextPageByCreatedAt(Map<String,Object> params) {
        return productsMapper.getNextPageByCreatedAt(params);
    }

    public void productDeleteUpdate(Products selectOne) {
        productsMapper.productDeleteUpdate(selectOne);
    }
}
