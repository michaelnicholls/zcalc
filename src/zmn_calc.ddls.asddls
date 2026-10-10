@EndUserText.label: 'calculator'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MNCALC'
define custom entity zmn_calc

{
//@UI.lineItem: [{ position: 10 }]

  key line : abap.int4;
  @UI.lineItem: [{ position: 20 }]
  @UI.selectionField: [{ position: 10 }]
  integer1 : abap.int4;
  @UI.lineItem: [{ position: 30 }]
  @UI.selectionField: [{ position: 20 }]
  operator : abap.char( 1 );
  @UI.lineItem: [{ position: 40 }]
  @UI.selectionField: [{ position: 30 }]
  integer2 : abap.int4;
  @UI.lineItem: [{ position: 50 }]
  text : abap.char( 100 );
  
}
