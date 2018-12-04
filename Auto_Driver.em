macro Auto_Driver()
{

	var SR;
    var hbuf;
    var auto_manual;
    auto_manual = 1;   
    
    auto_wnd = GetCurrentWnd ()
 //获得si中函数类型的名称   
    SymName = GetCurSymbol ()
    SR = GetSymbolLocation (SymName)
    FUNC_NAME = SR.type
    
//设置一个新的窗口，用于存为函数名
    out_buf = OpenBuf ("driver.c") 
    
 //获取本buf中所有的symbol数   
    index = 0
    hbuf = GetCurrentBuf()
    TotalSym = GetBufSymCount(hbuf)

  

    if(auto_manual == 1)
    {
          while(index < TotalSym)
          {
              SR = GetBufSymLocation(hbuf, index)
              if(FUNC_NAME == SR.type)
              {
              fill_driver(SR,hbuf)
              }
          index = index + 1          
          }
  
    }
    else
    {
    fill_driver(SR,hbuf)
    }   
    
    SetCurrentWnd (auto_wnd)  
stop

}

macro fill_driver(SR,hbuf)
{


    var out_buf;
    var SR_name;
    var temp_str;
    var left_bracket;
    var right_bracket;
    var par_list;
    var temp_cnt;
    var par_type;
    var par_name;
    var number;
    var one_par;
    var in_par_cnt;

    SR_name = SR.symbol;   

//设置一个新的窗口，用于存为函数名
    out_buf = OpenBuf ("driver.c") 	
    
 	temp_str ="	int	test_@SR_name@(int argc, char *argv[])"
 	AppendBufLine(out_buf, temp_str);
 	AppendBufLine(out_buf, "{");
 	AppendBufLine(out_buf,"	int rtn;")
 	

    temp_str = fill_func(hbuf,SR)
	left_bracket = CharInStr(temp_str,"(") 
	right_bracket = CharInStr(temp_str,")")	
	temp_str = strmid(temp_str,left_bracket + 1,right_bracket);
    par_list = give_pars_list(temp_str)

    temp_cnt = 0;
    while(temp_cnt < par_list.par_num)
    {
    temp_str = getbufline(par_list.pars_list,temp_cnt)
    par_type = temp_str.type
    par_name = temp_str.name;

    number = CharInStr(par_name,"*")
    if(number != -1)
    {
    	par_name = strmid(par_name,number+1,strlen(par_name))
    }

    
    temp_str = "	@par_type@	@par_name@;"
    AppendBufLine(out_buf, temp_str);
    temp_cnt = temp_cnt + 1;
    }
    AppendBufLine(out_buf,"");
    AppendBufLine(out_buf,"");    

//函数调用前，对输入参数的读入
    temp_cnt = 0;
    in_par_cnt = 2;
    while(temp_cnt < par_list.par_num)
    {
    temp_str = getbufline(par_list.pars_list,temp_cnt)
    par_type = temp_str.type
    par_name = temp_str.name;

    number = CharInStr(par_name,"*")
    if(number == -1)
    {
    	par_type = clean_tab_blank(par_type)
    	if(par_type == "SMEE_BOOL")
    	{
    		temp_str = "	if(!strcmp(\"SMEE_TRUE\",argv[@in_par_cnt@]))"
    		AppendBufLine(out_buf,temp_str)
    		temp_str = "	{"
    		AppendBufLine(out_buf,temp_str)
    		temp_str = "		@par_name@ = SMEE_TRUE;"
    		AppendBufLine(out_buf,temp_str)
    		temp_str = "	}"
    		AppendBufLine(out_buf,temp_str)

    		temp_str = "	if(!strcmp(\"SMEE_FALSE\",argv[@in_par_cnt@]))"
    		AppendBufLine(out_buf,temp_str)
    		temp_str = "	{"
    		AppendBufLine(out_buf,temp_str)
    		temp_str = "		@par_name@ = SMEE_FALSE;"
    		AppendBufLine(out_buf,temp_str)
    		temp_str = "	}"
    		AppendBufLine(out_buf,temp_str)    
    		in_par_cnt = in_par_cnt + 1	    		
    	}

		if(par_type == "int")
		{
			temp_str = "	@par_name@ = atoi(argv[@in_par_cnt@]);"
    		AppendBufLine(out_buf,temp_str)  			
    		in_par_cnt = in_par_cnt + 1				
		}
		if(par_type == "float" || par_type == "double")
		{
			temp_str = "	@par_name@ = atof(argv[@in_par_cnt@]);"
    		AppendBufLine(out_buf,temp_str)  			
    		in_par_cnt = in_par_cnt + 1				
		}	
    }
    

    temp_cnt = temp_cnt + 1;
    } 
    AppendBufLine(out_buf,"");
    AppendBufLine(out_buf,"");    





    temp_str = "	rtn = @SR_name@(";
    temp_cnt = 0;
    while(temp_cnt < par_list.par_num)
    {
    if(temp_cnt != 0)
    {
    temp_str = cat(temp_str,",")
    }
    one_par = getbufline(par_list.pars_list,temp_cnt)
    par_name = one_par.name;
    number = charInStr(par_name,"*")
    if(number != -1)
    {
    	par_name = strmid(par_name,number+1,strlen(par_name))
    	par_name = "&@par_name@"
    }
    temp_str = cat(temp_str,par_name)
    temp_cnt = temp_cnt + 1;
    }
    temp_str = cat(temp_str,");")
    AppendBufLine(out_buf,temp_str)
    temp_str = "	printf(\"rtn=%x\n\",rtn);"
    AppendBufLine(out_buf,temp_str)
    AppendBufLine(out_buf,"");
    AppendBufLine(out_buf,"");    
    


//处理函数调用后，对输出参数的打印
    temp_cnt = 0;
    while(temp_cnt < par_list.par_num)
    {
    one_par = getbufline(par_list.pars_list,temp_cnt)
    par_name = one_par.name;
    number = charInStr(par_name,"*")
    if(number != -1)
    {
    	par_name = strmid(par_name,number+1,strlen(par_name))
    	par_type = one_par.type
    	par_type = clean_tab_blank(par_type)
    	
    	if(par_type == "SMEE_BOOL")
    	{
    	temp_str = "	if(SMEE_TRUE == @par_name@)"
    	AppendBufLine(out_buf,temp_str);
    	temp_str = "	{"
    	AppendBufLine(out_buf,temp_str);
    	temp_str = "		printf(\"\\n@par_name@=SMEE_TRUE\\n\");"
    	AppendBufLine(out_buf,temp_str);
    	temp_str = "	}"
    	AppendBufLine(out_buf,temp_str);
    	temp_str = "	else"
    	AppendBufLine(out_buf,temp_str);
    	temp_str = "	{"
    	AppendBufLine(out_buf,temp_str);
    	temp_str = "		printf(\"\\n@par_name@=SMEE_FALSE\\n\");"
    	AppendBufLine(out_buf,temp_str);
    	temp_str = "	}"
    	AppendBufLine(out_buf,temp_str);    	
    	}

    	if(par_type == "int")
    	{
    	temp_str = "	printf(\"\\n@par_name@=%d\\n\",@par_name@);"
    	AppendBufLine(out_buf,temp_str);    	
    	}

    	if(par_type == "float")
    	{
    	temp_str = "	printf(\"\\n@par_name@=%f\\n\",@par_name@);"
    	AppendBufLine(out_buf,temp_str);       	
    	}
    	if(par_type == "double")
    	{
    	temp_str = "	printf(\"\\n@par_name@=%lf\\n\",@par_name@);"
    	AppendBufLine(out_buf,temp_str);       	
    	}
    }

    temp_cnt = temp_cnt + 1;
    }    
    
 	CloseBuf(par_list.pars_list);
 	AppendBufLine(out_buf,"}");
 	AppendBufLine(out_buf,"");
 	AppendBufLine(out_buf,"");	
 	return 0;
}
