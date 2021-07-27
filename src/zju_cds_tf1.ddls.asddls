@EndUserText.label: 'CDS Table Function'
define table function ZJU_CDS_TF1
with parameters 
@Environment.systemField: #CLIENT mandt:mandt, 
@Environment.systemField: #SYSTEM_LANGUAGE sy_langu:langu 

returns {
  mandt:mandt;
  country:land1;
  text:text50;
}

implemented by method zju_cl_country=>get_country_text;