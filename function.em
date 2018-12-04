/**************************************************************************
* Copyright (C) 2007, 上海微电子装备有限公司
* All rights reserved.
* 产品号 : SS B500/10
* 所属组件 : Struct.em
* 模块名称 : Struct.em
* 文件名称 : test.em
* 概要描述 : 本文件主要集中了对结构体解析的相关操作的宏。
* 历史记录 : 
* 版本    日期         作者        内容
* V1.0   2007-06-07    张方元      建立版本。
**************************************************************************/


/*--------------V1.0---------------------------------------------------------*/
//V1.0
//根据以前的各种宏整理出如下内容,
//1	-	自动插入trace
//2	-	自动插入data_req






/********************************************************************
*函数原型:
			macro FUNCTION_auto_data_req()
*参数说明:
			无
*功能说明:
			根据函数声明自动生成data_req代码，或者使用sscanf
*返回值:
			无
********************************************************************/
macro FUNCTION_auto_data_req()
{
	var hbuf			//数据缓冲
	var hwnd			//窗口句柄
	var ln				//行号
	var param_result		//参数解析结果缓冲
	var sz_text
	var Result
	var ln_trace
	var trace_result
	var index
	var flag
	var str
	var cch
	var len
	var layer_name
	var ch
	var all_str
	var data_req_flag
	var input
	var ln_data_req


    hwnd = GetCurrentWnd( )     // 取得当前窗口
    if(hwnd == 0)
        stop
    hbuf = GetCurrentBuf( )     // 取得当前文件缓冲

	ln = GetWndSelLnFirst (hwnd)	//取得当前的行号

	sz_text=GetBufLine(hbuf,ln)	//取得当前行内容

	all_str = sz_text

	cch='('						

	sz_text=GetBufLine(hbuf,ln)	//取得当前行内容

	len = strlen(sz_text)
	sz_text = strmid(sz_text, 4 ,len)//去掉 int RT

	index=0
	ch=sz_text[index]
	while(ch!="_")
	{
		index=index+1
		ch=sz_text[index]
	}
	layer_name= strtrunc (sz_text,index)	//取得层次名
	layer_name = toupper(layer_name)



	//解析参数
	param_result = FUNCTION_parse_param(all_str)
	
	//打印
	data_req_flag =1
	Result = FUNCTION_print_trace(param_result.param_buf, param_result.param_count,data_req_flag)

	Cursor_Down
//	input = ask("0- data_req,   1- scanf");

	input = 0
	if(input == 0)
	{
//		Insert_Line SetBufSelText ( hbuf, "if("# layer_name # "_DATAREQ_IS_ON == SMEE_TRUE)")
//		Insert_Line_Before_Next SetBufSelText ( hbuf, "{")	
//		Insert_Line_Before_Next SetBufSelText ( hbuf, "    TR4A_data_request(\"RT\", TR4A_REQ_INT_OUTPUT, func_name, NULL, \"Request_Flag = %d\",&Request_Flag);")	
//		Insert_Line_Before_Next SetBufSelText ( hbuf, "if(Request_Flag != 0)")	
//		Insert_Line_Before_Next SetBufSelText ( hbuf, "{")	


	//打印到代码中
	ln_data_req = ln + 1
	index = 0
	while(index < 30)
	{
		 
		trace_result = GetBufLine(hbuf,ln_data_req)		
//		msg trace_result
		flag = FindString(trace_result , "/*输入参数跟踪*/")
//		msg flag
		if(flag != "X")	//找到入口trace
		{
			break;
		}
		index = index +1
		ln_data_req = ln_data_req +1 	
	}
	if(index == 30)
	{
		msg "cant't find /*输入参数跟踪*/"
	}
	else
	{
		SetBufIns (hbuf, ln_data_req-1 , 0)
		Insert_Line_Before_Next SetBufSelText ( hbuf, "    /*输入参数数据请求*/")			
		if(Result.input_fmt == " ")
		{

			Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    TR4A_data_request(\"RT\", TR4A_REQ_EXT_OUTPUT, func_name, NULL, """ # Result.input_fmt)			
		}
		else
		{
			Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    TR4A_data_request(\"RT\", TR4A_REQ_EXT_OUTPUT, func_name, NULL, " # Result.input_fmt)		
		}
		Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")			
	}

	ln_data_req = ln_data_req + 1
	index = 0
	while(index < 100)
	{
		trace_result = GetBufLine(hbuf,ln_data_req)		
		flag = FindString(trace_result , "/*输出参数跟踪*/")
		if(flag != "X")	//找到入口trace
		{
			break;
		}
		index = index +1
		ln_data_req = ln_data_req +1 	
	}

	if(index == 30)
	{
		msg "cant find /*输出参数跟踪*/"
	}
	else
	{
		SetBufIns (hbuf, ln_data_req-1 , 0)
		Insert_Line_Before_Next SetBufSelText ( hbuf, "    /*输出参数数据请求*/")			
		if(Result.output_fmt == " ")
		{
			Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    TR4A_data_request(\"RT\", TR4A_REQ_EXT_OUTPUT, func_name, NULL, """ # Result.output_fmt)			
		}
		else
		{
			Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    TR4A_data_request(\"RT\", TR4A_REQ_EXT_OUTPUT, func_name, NULL, " # Result.output_fmt)		
		}
		Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")			
	}


//		Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")	
//		Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")	
	}
	else if(input == 1)
	{

		Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "sscanf(RT_INPUT_PARAM_STR," # Result.input_fmt)	
	}

	//关闭缓冲
	closeBuf(param_result.param_buf)


	stop
}

/********************************************************************
*函数原型:
			macro FUNCTION_auto_data_req()
*参数说明:
			无
*功能说明:
			根据函数声明自动生成插入trace代码。
*返回值:
			无
********************************************************************/
macro FUNCTION_auto_trace()
{
	var hbuf			//数据缓冲
	var hwnd			//窗口句柄
	var ln				//行号
	var param_result		//参数解析结果缓冲
	var sz_text
	var Result
	var ln_trace
	var trace_result
	var index
	var flag
	var str
	var trace_flag
    hwnd = GetCurrentWnd( )     // 取得当前窗口
    if(hwnd == 0)
        stop
    hbuf = GetCurrentBuf( )     // 取得当前文件缓冲

	ln = GetWndSelLnFirst (hwnd)	//取得当前的行号

	sz_text=GetBufLine(hbuf,ln)	//取得当前行内容

	//解析参数
	param_result = FUNCTION_parse_param(sz_text)
	
	//打印
	trace_flag = 0
	Result = FUNCTION_print_trace(param_result.param_buf, param_result.param_count,trace_flag)


	//打印到代码中
	ln_trace = ln + 1
	index = 0
	while(index < 30)
	{
		 
		trace_result = GetBufLine(hbuf,ln_trace)		
//		msg trace_result
		flag = FindString(trace_result , "RTSPDB_TRACE_IN")
//		msg flag
		if(flag != "X")	//找到入口trace
		{
			break;
		}
		index = index +1
		ln_trace = ln_trace +1 	
	}
	if(index == 30)
	{
		msg "cant find RTSPDB_TRACE_IN"
	}
	else
	{
		str = "        RTSPDB_TR_trace(func_name, RTSPDB_TRACE_IN, " # Result.input_fmt
		//msg str
		PutBufLine (hbuf, ln_trace, str)
	}

	ln_trace = ln_trace + 1
	index = 0
	while(index < 100)
	{
		trace_result = GetBufLine(hbuf,ln_trace)		
		flag = FindString(trace_result , "RTSPDB_TRACE_OUT")
		if(flag != "X")	//找到入口trace
		{
			break;
		}
		index = index +1
		ln_trace = ln_trace +1 	
	}

	if(index == 30)
	{
		msg "cant find RTSPDB_TRACE_OUT"
	}
	else
	{
		PutBufLine (hbuf, ln_trace, "        RTSPDB_TR_trace(func_name, RTSPDB_TRACE_OUT, " # Result.output_fmt)
	}


	
//	Insert_Line_Before_Next SetBufSelText ( hbuf, "RTSPDB_TR_trace(func_name, RTSPDB_TRACE_IN," # Result.input_fmt)
//	Insert_Line_Before_Next SetBufSelText ( hbuf, "RTSPDB_TR_trace(func_name, RTSPDB_TRACE_OUT," # Result.output_fmt)


	//关闭缓冲
	closeBuf(param_result.param_buf)

	stop
}

/********************************************************************
*函数原型:
			macro FUNCTION_parse_param(string)
*参数说明:
			string:输入的函数名称和参数。
*功能说明:
			解析函数中的参数，将其存储到一个param_buf当中
			param_buf的格式如下
			param_struct.type			参数类型
			param_struct.flag			输入或输出参数标志
			param_struct.variable		参数名称
			param_struct.index		参数类型所出现的第一个字符索引
			.....
			如此循环反复
*返回值:
			result: 已经打印完成的格式字符串
********************************************************************/
macro FUNCTION_parse_param(string)
{
	var result
	var param_buf	//存储解析结果的缓冲
	var index 		//当前索引
	var param_count	//参数的个数
	var first_ch_index	//取字符串时的第一个索引
	var last_ch_index	//取字符串时的最后一个索引	
 	var len			//所给的字符串长度
	var step_flag	//0-标表示查找类型  1-标识查找变量
	var point_flag	//是否存在"*"的标志
	var f_ch		//第一个字符
	var sz_text		//字符串
	var ch			//临时字符
	var param_struct	//解析结果单位


	//建立缓冲 
	param_buf = NewBuf ("param_buf")

	sz_text = string

	len = strlen(sz_text)

	//查找函数左括号	
	index=0
	ch=sz_text[index]
	while(ch!="(")
	{
		index=index+1
		ch=sz_text[index]
	}



	//以下为解析参数
	index = index + 1
	param_count = 0
	while( index <= len )
	{

		first_ch_index = index;
		last_ch_index = index;

		step_flag = 0;/*开始找类型*/
		point_flag = 0;/*默认不为指针*/

		while(1)
		{
			//使first_ch_index不为空格或者*
			f_ch = sz_text[first_ch_index]
			while( f_ch == " " || f_ch == "*")
			{
				if(f_ch == "*")
				{
					point_flag = 1;
				}
				first_ch_index = first_ch_index + 1

				//更新当前的index
				index = first_ch_index
				f_ch = sz_text[first_ch_index]
			}

			ch = sz_text[index]

			if(ch == " " || ch == "*" || ch == "," || ch == ")")
			{
				if(ch == "*")
				{
					point_flag = 1;
				}
			
				if(step_flag == 0)/*找到类型*/
				{	
					step_flag = 1
					
					last_ch_index = index ;

					param_struct.type = strmid(sz_text, first_ch_index, last_ch_index)
					param_struct.type_index = first_ch_index
					//Msg(param_struct.type)
					first_ch_index = index ;
				}
				else/*找到变量名*/
				{
					step_flag = 0
					last_ch_index = index ;
					param_struct.variable = strmid(sz_text, first_ch_index, last_ch_index)
					//Msg(param_struct.variable)
					first_ch_index = index ;
				}
				
				//使first_ch_index不为空格或者*
				f_ch = sz_text[first_ch_index]
				while( f_ch == " " || f_ch == "*")
				{
					if(f_ch == "*")
					{
						point_flag = 1;
					}
					first_ch_index = first_ch_index + 1

					//更新当前的index
					index = first_ch_index
					f_ch = sz_text[first_ch_index]
				}
			}

			ch = sz_text[index]
			if(ch == "," || ch == ")")
			{
				param_struct.flag = point_flag
				//Msg(param_struct)


				//将采集到的数据写入buff
				if(param_struct.type != "")
				{
					AppendBufLine(param_buf, param_struct.type)				
					AppendBufLine(param_buf, param_struct.flag)
					AppendBufLine(param_buf, param_struct.variable)
					AppendBufLine(param_buf, param_struct.type_index)
					param_count = param_count+1

				}
				
				index = index+1
				first_ch_index = index
				break;
			}
			
			index = index +1
		}
		if(ch == ")")
		{
			break
		}

	}

	result.param_buf = param_buf
	result.param_count = param_count

	return result
}

/********************************************************************
*函数原型:
			macro FUNCTION_print_trace(param_buf, param_count,flag)
*参数说明:
			param_buf:参数缓冲，由FUNCTION_parse_param生成。
			param_count:参数个数。
			flag:
				-0 表示trace
				-1 表示data_req
*功能说明:
			将函数中的参数按照格式打印
*返回值:
			Result.input_fmt	输入参数的格式，包括格式字符串和变量名
			Result.input_fmt	输出参数的格式，包括格式字符串和变量名
********************************************************************/
macro FUNCTION_print_trace(param_buf, param_count,flag)
{
	var index
	var ln_count	//param_buf的行数
	var param_index //参数索引
	var input_fmt	//输入参数的格式字符串
	var input_name	//输入参数的变量
	var output_fmt	//输出参数格式字符串
	var output_name	//输出参数的变量
	var type		
	var name
	var point_flag	//指针标志
	var type_index
	var unit_fmt	//单位格式%d,%g
	var var_struct_flag	//标识参数是变量或者结构体
	var hwnd
	var hbuf
	var ln
	var hwnd_new
	var hbuf_new
	var ln_new
	var wnd_sel
	var tmp_buf
	var struct_type
	var lay_num
	var htmpbuf //存放结构体解析的临时缓冲
	var struct_result
	var Result

	input_fmt = " "
	input_name = " "	
	output_fmt = " "
	output_name = " "
	unit_fmt = ""

	ln_count = GetBufLineCount (param_buf)

	param_index = 0
//	msg (param_count)
	while(param_index < param_count)
	{
		var_struct_flag = 0	//默认为变量
		type = ""
		type = GetBufLine (param_buf, param_index*4)	//查找类型
		point_flag = GetBufLine (param_buf, param_index*4 + 1)//查找输入或者输出标志
		name = GetBufLine (param_buf, param_index*4 + 2)	//查找变量名
		index = GetBufLine (param_buf, param_index*4 + 3)	//类型第一个字符的索引

		if(type == "double" || type == "float")
		{
			unit_fmt = " %g"
		}
		else if(type == "int" || type == "time_t" || type == "short" || type == "SMEE_BOOL")
		{
			unit_fmt = " %d"
		}
		else	//结构体或者指针
		{
		    hwnd = GetCurrentWnd( )     // 取得当前窗口
		    if(hwnd == 0)
		        stop
		    hbuf = GetCurrentBuf( )     // 取得当前文件缓冲

			ln = GetWndSelLnFirst (hwnd)	//取得当前的行号
		
			//设定焦点
			SetBufIns(hbuf, ln, index)

			Jump_To_Base_Type

			hwnd_new= GetCurrentWnd ( )//取得当前窗口
			if ( hwnd_new== 0 )
				stop
			hbuf_new= GetCurrentBuf ( )//取得当前文件缓冲
			ln_new = GetWndSelLnFirst (hwnd_new)	//取得当前的行号
			wnd_sel = GetWndSel (hwnd_new)
			tmp_buf =GetBufLine (hbuf_new, ln_new)
			struct_type = strmid (tmp_buf, wnd_sel.ichFirst, wnd_sel.ichLim)

			if(struct_type == "enum")
			{
				unit_fmt = " %d"
				Go_Back
			}

			//如果是结构体，循环解析
			if(struct_type == "struct")			
			{
				lay_num = 0
				htmpbuf = NewBuf("tmp_buf")
				STRUCT_auto_parse(htmpbuf, hwnd, hbuf, ln, lay_num)
				var_struct_flag = 1 //设定标志
			}
		}


		if(point_flag == 0)//输入参数
		{
			if(var_struct_flag == 1) //如果是结构体 
			{
				name = name # "."
				struct_result = FUNCTION_print_struct(htmpbuf, name, flag)
				input_fmt = input_fmt # struct_result.fmt 
				if(flag == 0)//trace
				{
					input_name = input_name # struct_result.name 
				}
				else //data_req
				{
					input_name = input_name # struct_result.name	 
				}

				closeBuf(htmpbuf)
			}
			else
			{
				input_fmt = input_fmt # name # "=" # unit_fmt # ","
				if(flag == 0)//trace
				{
					input_name = input_name # name # ","				
				}
				else //data_req
				{
					input_name = input_name # "\&" # name # ","							
				}

//				input_name = input_name # name # ","
 			}
		}
		else	//输出参数
		{
			if(var_struct_flag == 1) //如果是结构体 
			{
//				name = "(*" # name # ")"
				name = name # "->"				
				struct_result = FUNCTION_print_struct(htmpbuf, name, flag)
				output_fmt = output_fmt # struct_result.fmt 
				//output_name = output_name # struct_result.name

				if(flag == 0)//trace
				{
					output_name = output_name # struct_result.name 
				}
				else //data_req
				{
					output_name = output_name # struct_result.name 
				}
				closeBuf(htmpbuf)
			}
			else
			{
				name = "(*" # name # ")"
				output_fmt = output_fmt # name # "=" # unit_fmt # ","
				//output_name = output_name # name # ","
				if(flag == 0)//trace
				{
					output_name = output_name # name # ","				
				}
				else //data_req
				{
					output_name = output_name # "\&" # name # ","								
				}				
 			}		
		}
		param_index = param_index +1
	}

	//去除最后一个","

	//判断是否为空
//	if(input_name == " ")
//	{
//		Result.input_fmt = "\">()\");"
//	}
//	else
//	{
//		input_fmt = strmid(input_fmt, 0, strlen(input_fmt)-1)
//		input_name = strmid(input_name, 0, strlen(input_name)-1)
//		Result.input_fmt = "\">(" # input_fmt # ")\"," # input_name # ");"
//	}

//	if(output_name == " ")
//	{
//		Result.output_fmt = "\"<()=%s\", error_str);"
//	}
//	else
//	{
//		output_fmt = strmid(output_fmt, 0, strlen(output_fmt)-1)
//		output_name = strmid(output_name, 0, strlen(output_name)-1)
//		Result.output_fmt = "\"<(" # output_fmt # ")=%s\"," # output_name # ", error_str);"
//	}



	if(flag == 0)//trace
	{
		//判断是否为空
		if(input_name == " ")
		{
			Result.input_fmt = "\">()\");"
		}
		else
		{
			input_fmt = strmid(input_fmt, 0, strlen(input_fmt)-1)
			input_name = strmid(input_name, 0, strlen(input_name)-1)
			Result.input_fmt = "\">(" # input_fmt # ")\"," # input_name # ");"
		}

		if(output_name == " ")
		{
			Result.output_fmt = "\"<()=%s\", error_str);"
		}
		else
		{
			output_fmt = strmid(output_fmt, 0, strlen(output_fmt)-1)
			output_name = strmid(output_name, 0, strlen(output_name)-1)
			Result.output_fmt = "\"<(" # output_fmt # ")=%s\"," # output_name # ", error_str);"
		}
	}
	else //data_req
	{
		//判断是否为空
		if(input_name == " ")
		{
			Result.input_fmt = "NULL);"
		}
		else
		{
			input_fmt = strmid(input_fmt, 0, strlen(input_fmt)-1)
			input_name = strmid(input_name, 0, strlen(input_name)-1)
			Result.input_fmt = "\"(" # input_fmt # ")\"," # input_name # ");"
		}

		if(output_name == " ")
		{
			Result.output_fmt = "\"error_code = %x\", &error_code);"
		}
		else
		{
			msg output_name
			output_fmt = strmid(output_fmt, 0, strlen(output_fmt)-1)
			output_name = strmid(output_name, 0, strlen(output_name)-1)
			Result.output_fmt = "\"(" # output_fmt # ", error_code = %x)\"," # output_name # ", &error_code);"
		}
	}
//	msg Result.input_fmt
//	msg Result.output_fmt

	return Result
}


/********************************************************************
*函数原型:
			macro FUNCTION_print_trace(param_buf, param_count,flag)
*参数说明:
			htmpbuf:临时缓冲，由结构体解析宏生成
			var_name:变量名称
			flag:
				-0 表示trace
				-1 表示data_req
*功能说明:
			将结构体中的内容按照格式字符串和，变量串打印
*返回值:
			Result.name	结构体的名称字符串。
			Result.fmt	结构体的格式字符串。			
********************************************************************/
macro FUNCTION_print_struct(htmpbuf, var_name, flag)
{
	var ln_count //缓冲长度
	var ln		//当前行
	var print_buf	//打印缓冲
	var string		//打印的变量字符串
	var data		//解析后的数据	
	var ln_text		//指定行的数据
	var cur_lay		//当前层数

	var diff		//指定行层数与当前层数之差

	var index 		//字符个数索引

	var ch
	var hnewWnd
	var unit		//打印方式，单位
	var input	
	var Result

	Result.fmt = ""
	Result.name = ""
	
	ln_count = GetBufLineCount (htmpbuf)

//	print_buf = NewBuf ("print_buf")

	ln = 0

	cur_lay = 1

	input = var_name
	
	while(ln < ln_count)
	{

		ln_text = GetBufLine(htmpbuf,ln);
		data = STRUCT_parse_buf_line(ln_text)

		//如果是struct,修正相应的string
		if(data.union == "struct")
		{
			if(data.layer_num <= cur_lay)
			{
				diff = 	cur_lay - data.layer_num + 1	//如果两者相同，则需要减掉最后1个

				while(diff != 0 || string == nil)
				{
					index = strlen(string)

					if(index == 0)
					{
						break
					}
					index = index -2
					ch = string[index]
					while(ch != "." && index != 0)//查找倒数第2个".",或者为空
					{
						index = index -1
						ch = string[index]
					}
					if(index == 0)
					{
						string = nil
					}
					else
					{
						string = strmid(string, 0, index+1)					
					}
					diff = diff -1
				}

				//记录下当前的结构体
				string = cat (string, data.variable # ".")
			}
			else
			{//如果是更深一层的结构体
				string = cat (string, data.variable # ".")
			}
			//记录当前的层数
			cur_lay = data.layer_num
		}
		else
		{
			if(data.layer_num <= cur_lay)
			{
				diff = 	cur_lay - data.layer_num + 1	//如果两者相同，则需要减掉最后1个

				while(diff != 0 || string == nil)
				{
					index = strlen(string)

					if(index == 0)
					{
						break
					}

					index = index -2
					ch = string[index]
					while(ch != "." && index != 0)//查找倒数第2个".",或者为空
					{
						index = index -1
						ch = string[index]
					}

					if(index == 0)
					{
						string = nil
					}
					else
					{
						string = strmid(string, 0, index+1)					
					}

					diff = diff -1
				}
			}
			//记录当前的层数
			cur_lay = data.layer_num -1

			//将数据写入缓冲
			if(data.type == "float" || data.type == "double" )
			{
				unit = "%g"
			}
			else if(data.type == "char")
			{
				unit = "%c"			
			}
			else
			{
				unit = "%d"			
			}
			
			Result.fmt = Result.fmt # input  # string # data.variable  # "= " # unit # ","
//			Result.name = Result.name  # " " # input  # string # data.variable # ","

			if(flag == 0)//trace
			{
				Result.name = Result.name  # " " # input  # string # data.variable # ","
			}
			else //data_req
			{
				Result.name = Result.name  # " &" # input  # string # data.variable # ","
			}
		}

		ln = ln+1
	}

	return Result;

}


