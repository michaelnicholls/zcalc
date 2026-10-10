CLASS zcl_mncalc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mncalc IMPLEMENTATION.


  METHOD if_rap_query_provider~select.


    DATA lt_data TYPE TABLE OF zmn_calc.
    TRY.
        IF io_request->is_data_requested(  ).

          DATA(lo_filter) = io_request->get_filter(  ).
          IF lo_filter IS BOUND.
            DATA(lt_filter_ranges) = lo_filter->get_as_ranges(  ).
            READ TABLE lt_filter_ranges WITH KEY name = 'INTEGER1' ASSIGNING FIELD-SYMBOL(<lv_int1>).
            READ TABLE lt_filter_ranges WITH KEY name = 'INTEGER2' ASSIGNING FIELD-SYMBOL(<lv_int2>).
            READ TABLE lt_filter_ranges WITH KEY name = 'OPERATOR' ASSIGNING FIELD-SYMBOL(<lv_op>).


            DATA(lo_paging) = io_request->get_paging(  ).
            DATA(lv_offset) = lo_paging->get_offset(  ).
            DATA(lv_page_size) = lo_paging->get_page_size(  ).
            IF <lv_int1> IS NOT ASSIGNED OR <lv_int2> IS NOT ASSIGNED OR <lv_op> IS NOT ASSIGNED.
              lt_data = VALUE #( ( line = 10 text = 'Please supply Integer1, Operator, and Integer2' ) ).
            ELSE.
              DATA(linecounter) = 0.
              LOOP AT  <lv_int1>-range ASSIGNING FIELD-SYMBOL(<this_int1>).
                DATA(int1) = <this_int1>-low.
                LOOP AT <lv_op>-range ASSIGNING FIELD-SYMBOL(<this_op>).
                  DATA(op) = <this_op>-low.
                  LOOP AT <lv_int2>-range ASSIGNING FIELD-SYMBOL(<this_int2>).
                    DATA(int2) = <this_int2>-low.
                    data(formula) = |{ int1 } { op } { int2 }|.
                    DATA result TYPE p LENGTH 10 DECIMALS 2.
                    DATA(error) = ``.
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
                    linecounter += 1.
                    IF error IS NOT INITIAL.
                      lt_data = VALUE #( BASE lt_data (  formula = formula integer1 = int1 integer2 = int2 operator = op line = linecounter text = error ) ).
                    ELSE.
                      lt_data = VALUE #( BASE lt_data ( formula = formula integer1 = int1 integer2 = int2 line = linecounter operator = op text = |{ result }| ) ).
                    ENDIF.
                  ENDLOOP.
                ENDLOOP.
              ENDLOOP.
            ENDIF.
            io_response->set_data( lt_data ).
            io_response->set_total_number_of_records( lines( lt_data ) ).
          ENDIF.
        ENDIF.
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
