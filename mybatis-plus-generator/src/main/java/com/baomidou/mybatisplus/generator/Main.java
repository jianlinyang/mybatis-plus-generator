package com.baomidou.mybatisplus.generator;

import com.baomidou.mybatisplus.generator.config.DataSourceConfig;
import com.baomidou.mybatisplus.generator.config.builder.GeneratorBuilder;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;

import java.nio.file.Paths;

public class Main {
    /**
     * 数据源配置
     */
    private static final DataSourceConfig DATA_SOURCE_CONFIG = new DataSourceConfig
        .Builder("jdbc:mysql://mywsl:3306/test?serverTimezone=Asia/Shanghai", "yang", "123456")
        .schema("test")
        .build();

    public static void main(String[] args) {
        String userHome = System.getProperty("user.home");
        String workdir = Paths.get(userHome, "Documents\\code\\springdemo1\\src\\main\\java").toString();
        String packageName = "com.biz";
        AutoGenerator generator = new AutoGenerator(DATA_SOURCE_CONFIG);
        generator.strategy(GeneratorBuilder.strategyConfigBuilder()
            .entityBuilder()
            .enableLombok()
            .superClass("com.biz.entity.BaseEntity")
            .addSuperEntityColumns("create_time", "update_time")
            .enableFileOverride()
            .build());
        generator.global(GeneratorBuilder.globalConfigBuilder().author("yang").outputDir(workdir).build());
        generator.packageInfo(GeneratorBuilder.packageConfigBuilder()
            .parent(packageName)
//            .enableResource()
            .xml("mapper")
            .build());

        generator.execute(new FreemarkerTemplateEngine());
    }
}
