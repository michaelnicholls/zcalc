@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'value help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMN_OPS_VH as select from dd07t
{
    @UI.hidden: true
    key domname as domain_name,
    @UI.hidden: true
    key valpos as value_position,
    @UI.hidden: true
    key ddlanguage as language,
   // @UI.hidden: true
   @EndUserText.label: 'Value'
    domvalue_l as Value,
    @Semantics.text: true
    ddtext as Description
}
where domname = 'ZMN_OPS' and dd07t.as4local = 'A' and domvalue_l <> 'SPECIFIC'
