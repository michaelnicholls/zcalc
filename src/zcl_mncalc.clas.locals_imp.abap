*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_calc DEFINITION CREATE PRIVATE.
  		
  PUBLIC SECTION.
    TYPES:  lt_table   TYPE TABLE OF zmn_calc.
    class-METHODS calc IMPORTING  int1 TYPE int4 op TYPE string int2 TYPE int4
      CHANGING lt_data TYPE lt_table.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_calc IMPLEMENTATION.

  METHOD calc.
    data(formula) = |{ int1 } { op } { int2   }|.
    data(error) = ``.
    data result type p length 10 decimals 2.
    CASE op.
      WHEN '+'.
        result = int1 + int2.
      WHEN '-'.
        result = int1 - int2.
      WHEN '*'.
        result = int1 * int2.
      WHEN '/'.
        IF int2 = 0.
          error = 'No division by zero allowed'.
        ELSE.
          result = int1 / int2.
        ENDIF.
      WHEN OTHERS.
        error = 'Invalid operator'.
    ENDCASE.
    DATA(linecounter) = lines( lt_data ).
    linecounter += 1.
    IF error IS NOT INITIAL.
      lt_data = VALUE #( BASE lt_data (  formula = formula integer1 = int1 integer2 = int2 operator = op line = linecounter text = error text_packed = '0.0') ).
    ELSE.
      lt_data = VALUE #( BASE lt_data ( formula = formula integer1 = int1 integer2 = int2 line = linecounter operator = op
      text = |{ result  }| text_packed = result )  ).
    ENDIF.


  ENDMETHOD.

ENDCLASS.
