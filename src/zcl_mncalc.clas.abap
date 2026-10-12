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
          DATA(lt_params) = io_request->get_parameters(  ).
          DATA(lt_sort_elements)  = io_request->get_sort_elements(  ).

          DATA(lo_paging) = io_request->get_paging(  ).
          DATA(lv_offset) = lo_paging->get_offset(  ).
          DATA(lv_page_size) = lo_paging->get_page_size(  ).
          DATA(linecounter) = 0.
          IF lt_params IS NOT INITIAL.
            DATA(int1) = CONV i( lt_params[ parameter_name = 'P_INTEGER1' ]-value ).
            DATA(int2) = CONV i(  lt_params[ parameter_name = 'P_INTEGER2' ]-value ).
            DATA(op) = lt_params[  parameter_name = 'P_OPERATOR' ]-value.
            lcl_calc=>calc( exporting int1 = int1 int2 = int2 op = op changing lt_data = lt_data ).
 "           DATA(formula) = |{ int1 } { op } { int2   }|.
  "          lt_data = VALUE #( BASE lt_data ( formula = formula integer1 = int1 integer2 = int2 line = linecounter operator = op ) ).
          ELSE.
            DATA(lt_filter_ranges) = lo_filter->get_as_ranges(  ).
            READ TABLE lt_filter_ranges WITH KEY name = 'INTEGER1' ASSIGNING FIELD-SYMBOL(<lv_int1>).
            READ TABLE lt_filter_ranges WITH KEY name = 'INTEGER2' ASSIGNING FIELD-SYMBOL(<lv_int2>).
            READ TABLE lt_filter_ranges WITH KEY name = 'OPERATOR' ASSIGNING FIELD-SYMBOL(<lv_op>).

            IF <lv_int1> IS NOT ASSIGNED OR <lv_int2> IS NOT ASSIGNED OR <lv_op> IS NOT ASSIGNED.
              lt_data = VALUE #( ( line = 10 text_packed = '0.0' text = 'Please supply Integer1, Operator, and Integer2' ) ).
            ELSE.

              LOOP AT  <lv_int1>-range ASSIGNING FIELD-SYMBOL(<this_int1>).
                int1 = CONV i(  <this_int1>-low ).
                LOOP AT <lv_op>-range ASSIGNING FIELD-SYMBOL(<this_op>).
                  op = <this_op>-low.
                  LOOP AT <lv_int2>-range ASSIGNING FIELD-SYMBOL(<this_int2>).
                    int2 = CONV i(  <this_int2>-low ).
            lcl_calc=>calc( EXPORTING int1 = int1 int2 = int2 op = op  changing lt_data = lt_data ).
                  ENDLOOP.
                ENDLOOP.
              ENDLOOP.
            ENDIF.
          ENDIF.
          IF lt_sort_elements IS NOT INITIAL.
            " do any sorting
            DATA(lt_sort_criteria) = VALUE abap_sortorder_tab(
                FOR sort_element IN lt_sort_elements (
                    name = sort_element-element_name
                    descending = sort_element-descending )
                    ).
            " if we are sorting text, use text_packed
            LOOP AT lt_sort_criteria ASSIGNING FIELD-SYMBOL(<sort_crit>).
              IF <sort_crit>-name = 'TEXT'.
                <sort_crit>-name = 'TEXT_PACKED'.
              ENDIF.
            ENDLOOP.
            SORT lt_data BY (lt_sort_criteria).
          ENDIF.
          io_response->set_data( lt_data ).
          io_response->set_total_number_of_records( lines( lt_data ) ).
        ENDIF.
        "       ENDIF.
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
