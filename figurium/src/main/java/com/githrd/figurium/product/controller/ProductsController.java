package com.githrd.figurium.product.controller;

import com.githrd.figurium.product.dao.ProductsMapper;
import com.githrd.figurium.product.entity.Category;
import com.githrd.figurium.product.entity.Products;
import com.githrd.figurium.product.repository.CategoriesRepository;
import com.githrd.figurium.product.service.ProductsService;
import com.githrd.figurium.product.vo.ProductsVo;
import com.githrd.figurium.reviews.service.ReviewService;
import com.githrd.figurium.reviews.vo.ReviewVo;
import com.githrd.figurium.user.entity.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Controller
public class ProductsController {

    private final ProductsService productsService;
    private final ReviewService reviewService;
    private final CategoriesRepository categoriesRepository;
    private final HttpSession session;
    private ProductsMapper productsMapper;



    @Autowired
    public ProductsController(ProductsService productsService,
                              ReviewService reviewService,
                              CategoriesRepository categoriesRepository,
                              HttpSession session, ProductsMapper productsMapper) {
        this.productsService = productsService;
        this.reviewService = reviewService;
        this.categoriesRepository = categoriesRepository;
        this.session = session;
        this.productsMapper = productsMapper;
    }


    @RequestMapping("/productInfo.do")
    public String list(@RequestParam(value = "id" , required = false) Integer id,
                       Model model) {

        // 해상 상품에 해당하는 ID를 받아옴
        Products selectOne = productsService.getProductById(id);
        model.addAttribute("product", selectOne);

        // 해당 상품에 대한 ID 값을 이용해 리뷰의 리스트를 가져옴
        List<ReviewVo> reviewList = reviewService.reviewsByProductId(id);
        model.addAttribute("reviewList", reviewList);

        // 해당 상품에 대한 ID 값을 이용해 리뷰의 갯수를 가져옴
        int reviewCount = reviewService.reviewCountByProductId(id);
        model.addAttribute("reviewCount", reviewCount);

        return "products/productInfo";
    }

    @GetMapping("/productInsertForm.do")
    public String productInsertForm(Model model){
        List<Category> categoriesList = categoriesRepository.findAll();
        model.addAttribute("categoriesList", categoriesList);

        return "products/productInsertForm";
    }

    @RequestMapping("/productInsert.do")
    public String productInsert(ProductsVo products, @RequestParam MultipartFile productImage) {
        System.out.println(products);

        String save = productsService.ImageSave(products, productImage);

        if (save == null) {
            System.out.println("저장실패");
            return "redirect:/"; // 저장 실패 시 리다이렉션
        } else {
            System.out.println("등록성공");
            return "redirect:/"; // 저장 성공 시 리다이렉션
        }
    }


}


