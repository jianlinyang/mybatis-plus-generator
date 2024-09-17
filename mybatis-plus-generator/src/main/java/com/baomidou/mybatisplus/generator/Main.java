package com.baomidou.mybatisplus.generator;

import com.baomidou.mybatisplus.core.toolkit.StringPool;
import com.baomidou.mybatisplus.generator.config.DataSourceConfig;
import com.baomidou.mybatisplus.generator.config.OutputFile;
import com.baomidou.mybatisplus.generator.config.builder.GeneratorBuilder;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;

import java.io.File;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Objects;

public class Main {
    /**
     * 数据源配置
     */
    private static final DataSourceConfig DATA_SOURCE_CONFIG = new DataSourceConfig
        .Builder("jdbc:mysql://mywsl:3306/crawler?serverTimezone=Asia/Shanghai", "yang", "123456")
        .schema("crawler")
        .build();

    public static void main(String[] args) {
        String userHome = System.getProperty("user.home");
        String workdir = Paths.get(userHome, "Documents\\code\\crawler_center\\src\\main\\java").toString();
        String packageName = "app.biz";
        AutoGenerator generator = new AutoGenerator(DATA_SOURCE_CONFIG);
        generator.strategy(GeneratorBuilder.strategyConfigBuilder()
            .outputFile(
                (path, type) -> {
                    if (Objects.requireNonNull(type) == OutputFile.xml) {
                        String needReplace = "java" + File.separator + packageName.replaceAll("\\.", StringPool.BACK_SLASH + File.separator);
                        return new File(path.replace(needReplace, "resources"));
                    }
                    return new File(path);
                }
            )
            .controllerBuilder()
            .enableRestStyle()
            //.enableFileOverride()
            .entityBuilder()
            .enableLombok()
            .superClass("app.common.BaseEntity")
            .addSuperEntityColumns("create_time", "update_time")
            //.enableFileOverride()
            .dtoBuilder()
            .enableIdEncrypt()
            .enableLombok()
            .superClass("app.common.BaseDTO")
            //.enableFileOverride()
            .converterBuilder()
            //.enableFileOverride()
            .build());
        generator.global(GeneratorBuilder.globalConfigBuilder().author("yang").outputDir(workdir).build());
        generator.packageInfo(GeneratorBuilder.packageConfigBuilder()
            .parent(packageName)
            .xml("mapper")
            .build());
        HashMap<String, Object> customMap = new HashMap<>();
        customMap.put("idInfoPackage", "app.common.IdInfo");
        customMap.put("pageInfoPackage", "app.common.PageInfo");
        customMap.put("responsePackage", "app.common.Response");
        generator.injection(GeneratorBuilder.injectionConfigBuilder()
            .customMap(customMap)
            .build());
        generator.execute(new FreemarkerTemplateEngine(), false);
    }
}
