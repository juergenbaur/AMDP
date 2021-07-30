CLASS zju_amdp_join DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_amdp_marker_hdb,
      if_oo_adt_classrun.

    TYPES:
      BEGIN OF ty_result_line,
        carrier TYPE /dmo/carrier_id,
        name    TYPE /dmo/carrier_name,
*       connection_id TYPE /dmo/connection_id,
*        flight_date   TYPE /dmo/flight_date,
*        price         TYPE /dmo/flight_price,
*        currency_code TYPE  /dmo/currency_code,
      END OF ty_result_line,

      ty_result_table TYPE STANDARD TABLE OF ty_result_line WITH EMPTY KEY,
      ty_flights      TYPE STANDARD TABLE OF /dmo/flight.

* https://www.youtube.com/watch?v=_sdswDyEE-A
    METHODS join
      EXPORTING
                VALUE(result) TYPE ty_result_table
      RAISING   cx_amdp_execution_error.



  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zju_amdp_join IMPLEMENTATION.



  METHOD join BY DATABASE PROCEDURE
                                    FOR HDB
                                    LANGUAGE SQLSCRIPT
                                    OPTIONS READ-ONLY USING /dmo/flight
                                                            /dmo/carrier.

    result = select t1.carrier_id as carrier, t2.name
    from "/DMO/FLIGHT" as t1
    INNER JOIN "/DMO/CARRIER" as t2
    on t1.carrier_id = t2.carrier_id
    GROUP BY t1.carrier_id, t2.name
    order by t1.carrier_id;



  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    TRY.

        me->join(
          IMPORTING
            result =  DATA(lt_result) ).

      CATCH cx_amdp_execution_error INTO DATA(lx_amdp).
        out->write( lx_amdp->get_longtext( ) ).
    ENDTRY.

    out->write( lt_result ).


  ENDMETHOD.


ENDCLASS.
