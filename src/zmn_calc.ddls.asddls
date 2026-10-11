@EndUserText.label: 'calculator'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MNCALC'
define custom entity zmn_calc

{
//@UI.lineItem: [{ position: 10 }]

  key line : abap.int4;
  //@UI.lineItem: [{ position: 20 }]
  @UI.selectionField: [{ position: 10 }]
  @EndUserText.label: 'Integer1'
  integer1 : abap.int4;
 // @UI.lineItem: [{ position: 30 }]
  @UI.selectionField: [{ position: 20 }]
  @Consumption.valueHelpDefinition: [{ entity: {name: 'ZMN_OPS_VH', element: 'Value' }}]
 
  operator : zmn_ops;
 // @UI.lineItem: [{ position: 40 }]
  @UI.selectionField: [{ position: 30 }]
   @EndUserText.label: 'Integer2'
  integer2 : abap.int4;
  @UI.lineItem: [{ position: 45 }]
  @EndUserText.label: 'Formula'
  formula : abap.char(30);
  @UI.lineItem: [{ position: 50 }]
  @EndUserText.label: 'Result'
  text : abap.char( 100 );
  @UI.hidden: true
  text_packed : abap.dec( 10, 2 );
  
}
