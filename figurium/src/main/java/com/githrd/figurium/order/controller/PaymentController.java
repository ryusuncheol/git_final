package com.githrd.figurium.order.controller;

import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.exception.IamportResponseException;
import com.siot.IamportRestClient.response.IamportResponse;
import com.siot.IamportRestClient.response.Payment;
import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.util.Locale;

@Controller
@Slf4j  // 로깅을 위한 log 객체를 자동으로 생성
@RequiredArgsConstructor    // 알아서 private로 지정되어있는 필드 생성자로 생성
public class PaymentController {

    // iamport를 사용하기 위해서 api를 불러온다.
    private IamportClient api;
    private HttpSession session;

    // application.properties에 암호를 저장하여 Controller에 기록이 안되게 암호화 시킴
    @Value("${imp.api.key}")
    private String apiKey;

    @Value("${imp.api.secretkey}")
    private String secretKey;

    // api를 사용하기 위해서는 apiKey와 apiSecret키를 넣어준다.
    @PostConstruct
    public void init() {
        this.api = new IamportClient(apiKey, secretKey);
    }

    @ResponseBody   // JSON 형태로 반환
    @RequestMapping(value="/verifyIamport/{imp_uid}")
    public IamportResponse<Payment> paymentByImpUid(Model model, Locale locale, HttpSession session,
                                                    @PathVariable(value="imp_uid") String imp_uid)
            throws IamportResponseException, IOException {
        // @PathVariable(value="imp_uid")로 지정된 값을 String imp_uid에 지정
        // 특졍 결제 ID(imp_uid)를 기반으로 결제 정보 조회 후 JSON으로 클라이언트에게 응답
        return api.paymentByImpUid(imp_uid);
    }
}
