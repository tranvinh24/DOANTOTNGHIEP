package org.example.PhongTro.exception;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(value = Exception.class)
    public ResponseEntity<Map<String, Object>> handlingRuntimeException(RuntimeException exception) {
        Map<String, Object> response = new HashMap<>();
        response.put("code", ErrorCode.UNCATEGORIZED_EXCEPTION.getCode());
        response.put("message", ErrorCode.UNCATEGORIZED_EXCEPTION.getMessage());

        return ResponseEntity.status(ErrorCode.UNCATEGORIZED_EXCEPTION.getStatusCode()).body(response);
    }

    @ExceptionHandler(value = AppException.class)
    public ResponseEntity<Map<String, Object>> handlingAppException(AppException exception) {
        ErrorCode errorCode = exception.getErrorCode();

        Map<String, Object> response = new HashMap<>();
        response.put("code", errorCode.getCode());
        response.put("message", errorCode.getMessage());

        return ResponseEntity.status(errorCode.getStatusCode()).body(response);
    }

    @ExceptionHandler(value = MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handlingValidation(MethodArgumentNotValidException exception) {
        String enumKey = exception.getFieldError() != null ? exception.getFieldError().getDefaultMessage() : null;

        ErrorCode errorCode = ErrorCode.INVALID_KEY;
        try {
            if (enumKey != null) {
                errorCode = ErrorCode.valueOf(enumKey);
            }
        } catch (IllegalArgumentException e) {
            // giữ mặc định INVALID_KEY nếu message không phải là tên enum
        }

        Map<String, Object> response = new HashMap<>();
        response.put("code", errorCode.getCode());
        response.put("message", errorCode.getMessage());

        return ResponseEntity.status(errorCode.getStatusCode()).body(response);
    }
}
