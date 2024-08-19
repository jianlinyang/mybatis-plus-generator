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
import ${package.Entity}.${tableInfo.entityName};
import ${package.Service}.${tableInfo.serviceName};
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

    private final ISysUserService sysUserService;
    private final SysUserConverter sysUserConverter;

    /**
     * 新增
     */
    @PostMapping("/create")
    @Transactional(rollbackFor = Exception.class)
    public Response<Long> save(@Valid @RequestBody SysUserCreateDTO createDTO) {
        SysUser entity = sysUserConverter.toEntity(createDTO);
        sysUserService.save(entity);
        return Response.success(entity.getId());
    }

    /**
     * 查询单个记录
     */
    @GetMapping("/query")
    public Response<SysUserQueryDTO> query(@Valid SysUserQueryDTO queryDTO) {
        QueryWrapper<SysUser> query = Wrappers.query();
        Map<String, Object> condition = BeanUtil.beanToMap(queryDTO, true, true);
        query.allEq(condition, false);
        SysUser entity = sysUserService.getOne(query, false);
        SysUserQueryDTO readDTO = sysUserConverter.toQuery(entity);
        return Response.success(readDTO);
    }

    /**
     * 查询列表
     */
    @GetMapping("/list")
    public Response<List<SysUserQueryDTO>> list(@Valid SysUserQueryDTO queryDTO, PageInfo pageInfo) {
        QueryWrapper<SysUser> query = Wrappers.query();
        Map<String, Object> condition = BeanUtil.beanToMap(queryDTO, true, true);
        query.allEq(condition, false);
        if (pageInfo.getPageNumber() == null || pageInfo.getPageSize() == null) {
            return Response.success(sysUserService.list(query).stream().map(sysUserConverter::toQuery).collect(Collectors.toList()));
        } else {
            Page<SysUser> page = new Page<>(pageInfo.getPageNumber(), pageInfo.getPageSize());
            return Response.success(sysUserService.list(page, query).stream().map(sysUserConverter::toQuery).collect(Collectors.toList()), page.getTotal());
        }
    }

    /**
     * 修改
     */
    @PostMapping("/update")
    @Transactional(rollbackFor = Exception.class)
    public Response<String> update(@Valid @RequestBody SysUserUpdateDTO createDTO) {
        SysUser entity = sysUserConverter.toEntity(createDTO);
        sysUserService.updateById(entity);
        return Response.success("修改成功");
    }

    /**
     * 删除
     */
    @PostMapping("/delete")
    public Response<String> delete(@RequestBody IdInfo idInfo) {
        if (idInfo.getId() != null) {
            sysUserService.removeById(idInfo.getId());
        }
        if (idInfo.getIds() != null) {
            sysUserService.removeBatchByIds(idInfo.getIds());
        }
        return Response.success("删除成功");
    }
}
</#if>
