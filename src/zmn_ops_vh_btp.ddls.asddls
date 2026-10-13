@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'value help for BTP'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMN_OPS_VH_BTP as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T(p_domain_name: 'ZMN_OPS')
{
    @UI.hidden: true
    key domain_name,
    @UI.hidden: true
    key value_position,

   // @UI.hidden: true
   @EndUserText.label: 'Value'
    value_low,
    @Semantics.text: true
    text
}
