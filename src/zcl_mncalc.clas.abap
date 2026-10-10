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
              lt_data = VALUE #( ( line = 10 text = 'Please supply integer1, operator, and integer2' ) ).
            ELSE.
              DATA(int1) =  <lv_int1>-range[ 1 ]-low.
              DATA(int2) =  <lv_int2>-range[ 1 ]-low.
              DATA(op) = <lv_op>-range[ 1 ]-low.
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
              IF error IS NOT INITIAL.
                lt_data = VALUE #( (   integer1 = int1 integer2 = int2 operator = op line = 10 text = error ) ).
              ELSE.
                lt_data = VALUE #( ( integer1 = int1 integer2 = int2 line = 10 operator = op text = |Result: { result }| ) ).
              ENDIF.
            ENDIF.
            io_response->set_data( lt_data ).
            io_response->set_total_number_of_records( lines( lt_data ) ).
          ENDIF.
        ENDIF.
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
