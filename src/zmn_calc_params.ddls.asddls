@EndUserText.label: 'calculator'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MNCALC'
define custom entity ZMN_CALC_PARAMS
  with parameters
    @EndUserText.label: 'Integer1'
    p_integer1 : zmn_integer,
    @Consumption.valueHelpDefinition: [{ entity: {name: 'ZMN_OPS_VH', element: 'Value' }}]

    p_operator   : zmn_ops,
    @EndUserText.label: 'Integer2'
    p_integer2 : zmn_integer

{

  key line        : abap.int4;
      @UI.lineItem: [{ position: 45 }]
      @EndUserText.label: 'Formula'
      formula     : abap.char(30);
      @UI.lineItem: [{ position: 50 }]
      @EndUserText.label: 'Result'
      text        : abap.char( 100 );
      @UI.hidden  : true
      text_packed : abap.dec( 10, 2 );

}
