CLASS zju_amdp_order_by DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_amdp_marker_hdb,
      if_oo_adt_classrun.

    TYPES:

      BEGIN OF ty_aggregation_line,
        carrier_id    TYPE  /dmo/carrier_id,
        plane_type_id TYPE /dmo/plane_type_id,
        price         TYPE /dmo/flight_price,
        currency_code TYPE /dmo/currency_code,
        seats_max     TYPE /dmo/plane_seats_max,
      END OF ty_aggregation_line,

      ty_aggregation_table TYPE STANDARD TABLE OF ty_aggregation_line WITH EMPTY KEY.


    METHODS order_by
      EXPORTING
                VALUE(result) TYPE ty_aggregation_table
      RAISING   cx_amdp_execution_error.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zju_amdp_order_by IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TRY.
        me->order_by(
        IMPORTING
            result = DATA(lt_result) ).


      CATCH cx_amdp_execution_error INTO DATA(lx_amdp).
        out->write( lx_amdp->get_longtext( ) ).
    ENDTRY.

    out->write( lt_result ).

  ENDMETHOD.


  METHOD order_by BY DATABASE PROCEDURE
                                    FOR HDB
                                    LANGUAGE SQLSCRIPT
                                    OPTIONS READ-ONLY USING /dmo/flight.

    result = select carrier_id, plane_type_id, price, currency_code, seats_max
                   from "/DMO/FLIGHT"
                  order BY carrier_id asC, plane_type_id desc;

  ENDMETHOD.

ENDCLASS.
