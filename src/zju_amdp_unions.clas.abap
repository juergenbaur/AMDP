CLASS zju_amdp_unions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_amdp_marker_hdb,
      if_oo_adt_classrun.

    TYPES:

      BEGIN OF ty_aggregation_line,
        carrier_id TYPE  /dmo/carrier_id,
*        name          TYPE /dmo/carrier_name,
*        average       TYPE /dmo/flight_price,
*        currency_code TYPE /dmo/currency_code,
      END OF ty_aggregation_line,

      ty_aggregation_table TYPE STANDARD TABLE OF ty_aggregation_line WITH EMPTY KEY.


    METHODS execute
      EXPORTING
                VALUE(result) TYPE ty_aggregation_table
      RAISING   cx_amdp_execution_error.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zju_amdp_unions IMPLEMENTATION.


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

    result = ( select carrier_id from "/DMO/FLIGHT" )
                 union
            (  select carrier_id from "/DMO/CARRIER" );


  ENDMETHOD.

ENDCLASS.
