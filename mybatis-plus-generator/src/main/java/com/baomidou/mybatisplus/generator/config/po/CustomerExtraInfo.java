package com.baomidou.mybatisplus.generator.config.po;

import com.baomidou.mybatisplus.generator.config.ConstVal;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CustomerExtraInfo {

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class PackageAndClass {
        private String packageName;
        private String className;
    }

    private PackageAndClass entity = new PackageAndClass();
    private List<PackageAndClass> dtos = new ArrayList<>();
    private PackageAndClass converter = new PackageAndClass();
    private PackageAndClass controller = new PackageAndClass();

}
