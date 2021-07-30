CLASS zju_amdp_sub_select DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_amdp_marker_hdb,
      if_oo_adt_classrun.

    TYPES:

      BEGIN OF ty_aggregation_line,
        carrier_id    TYPE  /dmo/carrier_id,
        name          TYPE /dmo/carrier_name,
        average       TYPE /dmo/flight_price,
        currency_code TYPE /dmo/currency_code,
      END OF ty_aggregation_line,

      ty_aggregation_table TYPE STANDARD TABLE OF ty_aggregation_line WITH EMPTY KEY.


    METHODS execute
      EXPORTING
                VALUE(result) TYPE ty_aggregation_table
      RAISING   cx_amdp_execution_error.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zju_amdp_sub_select IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TRY.
        me->execute(
        IMPORTING
            result = DATA(lt_result) ).


      CATCH cx_amdp_execution_error INTO DATA(lx_amdp).
        out->write( lx_amdp->get_longtext( ) ).
    ENDTRY.

    out->write( lt_result ).

  ENDMETHOD.


  METHOD execute BY DATABASE PROCEDURE
                                    FOR HDB
                                    LANGUAGE SQLSCRIPT
                                    OPTIONS READ-ONLY USING /dmo/flight
                                                            /dmo/carrier.

    declare average dec(16,2);

    select round(avg(price),1 ) into average from "/DMO/FLIGHT";

    result = select t1.carrier_id, t2.name, round(AVG(t1.price),1) as average, t1.currency_code
                   from "/DMO/FLIGHT" as t1, "/DMO/CARRIER" as t2
                   where t1.carrier_id = t2.carrier_id
                  GROUP BY t1.carrier_id, name, t1.currency_code
                  HAVING avg(price) >
                  ( select round( avg( price ),1 )as average from "/DMO/FLIGHT" )
                  order by carrier_id;

  ENDMETHOD.

ENDCLASS.
