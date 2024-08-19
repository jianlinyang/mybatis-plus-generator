package ${package.DTO};

import jakarta.validation.constraints.*;
<#if dtoLombokModel>
import lombok.Data;
    <#if superDTOClass??>
import lombok.EqualsAndHashCode;
    </#if>
    <#if dtoChainModel>
import lombok.experimental.Accessors;
    </#if>
</#if>
<#if enableSerialAnnotate>

import java.io.Serial;
</#if>
<#list dtoImportPackages as pkg>
import ${pkg};
</#list>
<#if springdoc>
import io.swagger.v3.oas.annotations.media.Schema;
<#elseif swagger>
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
</#if>
import java.util.Map;
import java.util.TreeMap;
/**
 * ${table.comment!}
 *
 * @author ${author}
 * @since ${date}
 */
<#if dtoLombokModel>
<#if superDTOClass??>
@EqualsAndHashCode(callSuper = true)
</#if>
@Data
    <#if dtoChainModel>
@Accessors(chain = true)
    </#if>
</#if>
<#if springdoc>
@Schema(name = "${dto}", description = "${table.comment!}")
<#elseif swagger>
@ApiModel(value = "${dto}对象", description = "${table.comment!}")
</#if>
<#if superDTOClass??>
public class ${dto} extends ${superDTOClass}<#if activeRecord><${dto}></#if> {
<#elseif activeRecord>
public class ${dto} extends Model<${dto}> {
<#elseif dtoSerialVersionUID>
public class ${dto} implements Serializable {
<#else>
public class ${dto} {
</#if>
<#if dtoSerialVersionUID>
    <#if enableSerialAnnotate>
    @Serial
    </#if>
    private static final long serialVersionUID = 1L;
</#if>
<#-- ----------  BEGIN 字段循环遍历  ---------->
<#list dtoFields as field>
    <#if field.comment!?length gt 0>
        <#if springdoc>
    @Schema(description = "${field.comment}")
        <#elseif swagger>
    @ApiModelProperty("${field.comment}")
        <#else>
    /**
     * ${field.comment}
     */
        </#if>
    </#if>
    <#list field.validAnnotations as validannotation>
    ${validannotation}
    </#list>
    private ${field.propertyType} ${field.propertyName};
</#list>
<#------------  END 字段循环遍历  ---------->
<#if !dtoLombokModel>
    <#list dtoFields as field>
        <#if field.propertyType == "boolean">
            <#assign getprefix="is"/>
        <#else>
            <#assign getprefix="get"/>
        </#if>

    public ${field.propertyType} ${getprefix}${field.capitalName}() {
        return ${field.propertyName};
    }

    <#if dtoChainModel>
    public ${dto} set${field.capitalName}(${field.propertyType} ${field.propertyName}) {
    <#else>
    public void set${field.capitalName}(${field.propertyType} ${field.propertyName}) {
    </#if>
        this.${field.propertyName} = ${field.propertyName};
        <#if dtoChainModel>
        return this;
        </#if>
    }
    </#list>
</#if>
<#if dtoColumnConstant>
    <#list dtoFields as field>

    public static final String ${field.name?upper_case} = "${field.name}";
    </#list>
</#if>
<#if !dtoLombokModel>

    @Override
    public String toString() {
        return "${dto}{" +
    <#list dtoFields as field>
        <#if field_index==0>
            "${field.propertyName} = " + ${field.propertyName} +
        <#else>
            ", ${field.propertyName} = " + ${field.propertyName} +
        </#if>
    </#list>
        "}";
    }
</#if>
    /**
    * 字段名与注释的映射
    */
    public static Map<String, String> fields = new TreeMap<>();

    static {
<#list dtoFields as field>
        fields.put("${field.propertyName}", "${field.comment}");
</#list>
    }
}
