package ${package.Converter};

import ${package.Entity}.${table.entityName};
<#list dtoList as dtoName>
import ${package.DTO}.${dtoName};
</#list>
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;

/**
 * ${table.comment!} converter
 *
 * @author ${author}
 * @since ${date}
 */
@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface ${table.converterName} {
<#list convertMethods as m>
    ${m}
</#list>
}

