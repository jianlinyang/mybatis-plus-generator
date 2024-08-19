package ${package.Controller};

import cn.hutool.core.bean.BeanUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
<#list dtoList as dtoName>
import ${package.DTO}.${dtoName};
</#list>
import ${idInfoPackage};
import ${pageInfoPackage};
import ${responsePackage};
import ${package.Entity}.${table.entityName};
import ${package.Service}.${table.serviceName};
import ${package.Converter}.${table.converterName};
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
<#if restControllerStyle>
import org.springframework.web.bind.annotation.RestController;
<#else>
import org.springframework.stereotype.Controller;
</#if>
<#if superControllerClassPackage??>
import ${superControllerClassPackage};
</#if>
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * ${table.comment!} 前端控制器
 *
 * @author ${author}
 * @since ${date}
 */
@Slf4j
<#if restControllerStyle>
@RestController
<#else>
@Controller
</#if>
@RequiredArgsConstructor
@RequestMapping("<#if package.ModuleName?? && package.ModuleName != "">/${package.ModuleName}</#if>/<#if controllerMappingHyphenStyle>${controllerMappingHyphen}<#else>${table.entityPath}</#if>")
<#if kotlin>
class ${table.controllerName}<#if superControllerClass??> : ${superControllerClass}()</#if>
<#else>
<#if superControllerClass??>
public class ${table.controllerName} extends ${superControllerClass} {
<#else>
public class ${table.controllerName} {
</#if>

    private final ${table.serviceName} ${entityLowerFirst}Service;
    private final ${table.converterName} ${entityLowerFirst}Converter;
<#if createDTO??>

    /**
     * 新增
     */
    @PostMapping("/create")
    @Transactional(rollbackFor = Exception.class)
    public Response<Long> save(@Valid @RequestBody ${createDTO} createDTO) {
        ${entity} entity = ${entityLowerFirst}Converter.toEntity(createDTO);
        ${entityLowerFirst}Service.save(entity);
        return Response.success(entity.get${table.primaryColumn}());
    }
</#if>
<#if queryDTO??>

    /**
     * 查询单个记录
     */
    @GetMapping("/query")
    public Response<${queryDTO}> query(@Valid ${queryDTO} queryDTO) {
        QueryWrapper<${entity}> query = Wrappers.query();
        Map<String, Object> condition = BeanUtil.beanToMap(queryDTO, true, true);
        query.allEq(condition, false);
        ${entity} entity = ${entityLowerFirst}Service.getOne(query, false);
        return Response.success(${entityLowerFirst}Converter.toQuery(entity));
    }

    /**
     * 查询列表
     */
    @GetMapping("/list")
    public Response<List<${queryDTO}>> list(@Valid ${queryDTO} queryDTO, PageInfo pageInfo) {
        QueryWrapper<${entity}> query = Wrappers.query();
        Map<String, Object> condition = BeanUtil.beanToMap(queryDTO, true, true);
        query.allEq(condition, false);
        if (pageInfo.getPageNumber() == null || pageInfo.getPageSize() == null) {
            return Response.success(${entityLowerFirst}Service.list(query).stream().map(${entityLowerFirst}Converter::toQuery).collect(Collectors.toList()));
        } else {
            Page<${entity}> page = new Page<>(pageInfo.getPageNumber(), pageInfo.getPageSize());
            return Response.success(${entityLowerFirst}Service.list(page, query).stream().map(${entityLowerFirst}Converter::toQuery).collect(Collectors.toList()), page.getTotal());
        }
    }
</#if>

<#if updateDTO??>
    /**
     * 修改
     */
    @PostMapping("/update")
    @Transactional(rollbackFor = Exception.class)
    public Response<String> update(@Valid @RequestBody ${updateDTO} updateDTO) {
        ${entity} entity = ${entityLowerFirst}Converter.toEntity(updateDTO);
        ${entityLowerFirst}Service.updateById(entity);
        return Response.success("修改成功");
    }
</#if>

    /**
     * 删除
     */
    @PostMapping("/delete")
    public Response<String> delete(@RequestBody IdInfo idInfo) {
        if (idInfo.getId() != null) {
            ${entityLowerFirst}Service.removeById(idInfo.getId());
        }
        if (idInfo.getIds() != null) {
            ${entityLowerFirst}Service.removeBatchByIds(idInfo.getIds());
        }
        return Response.success("删除成功");
    }
}
</#if>
