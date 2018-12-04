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
* V1.0   2007-03-26    张方元      创建文件
* V1.1   2007-03-26    张方元      增加对数组解析的支持
* V1.2   2007-06-06    张方元      对原来的Test.em各个宏进行整理
									增加对unsigned的支持
**************************************************************************/

/*--------------V1.0---------------------------------------------------------*/
//V1.0
//初步完成结构体解析功能
//temp_buf格式
//"~" + "层号" + "$" + "变量名称" + "!" + "变量类型" + "&" + "元素或者结构" + "*"

/*--------------V1.1---------------------------------------------------------*/
//V1.1
//增加对数组解析的支持
//dimension_tmp_buf格式
//第一行为总得维数,以后依次存放相应得维数
//array_tmp_buff格式
//[0][0][0],....,
//[0][0][1]
//....
//[i-1],[j-1],[k-1]

/*--------------V1.2---------------------------------------------------------*/
//V1.2
//在STRUCT_parse_line中增加部分代码，对unsigned支持
//约定所有结构体操作的宏都以STRUCT为起始名称
//原版parse_struct改为 STRUCT_auto_parse
//原版parse_line  改为 STRUCT_parse_line
//原版mcaro_to_number 改为 STRUCT_mcaro_to_number
//原版write_array_format 改为 STRUCT_write_array_format
//原版parse_buff 改为 STRUCT_parse_buf_line
//原版write_MC_file 改为STRUCT_write_MC_file
//原版auto_printf 改为STRUCT_auto_printf
//原版test_struct 改为 STRUCT_test_use



/********************************************************************
*函数原型:
			macro STRUCT_test_use()
*参数说明:
			无
*功能说明:
			对结构体的单独使用的两种方法
			1 生成机器常数文件
			2 使用printf方式打印
*返回值:
			无
********************************************************************/
macro STRUCT_test_use()
{
	var hbuf			//数据缓冲
	var hwnd			//窗口句柄
	var ln				//行号
	var htmpbuf
	var hnewWnd
	var input			//输入
	var lay_num			//层数


	hwnd = GetCurrentWnd ( )//取得当前窗口
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//取得当前文件缓冲

	htmpbuf = NewBuf ("tmp_buf")

	ln = GetWndSelLnFirst (hwnd)	//取得当前的行号

	lay_num = 0;

	Jump_To_Base_Type
	
	STRUCT_auto_parse(htmpbuf, hwnd, hbuf, ln, lay_num)

    hnewWnd = NewWnd(htmpbuf)


	input = Ask ("输入:0-自动打印,1-生成机器常数文件")

	//自动打印
	if(input == 0)
	{
		STRUCT_auto_printf (htmpbuf)
	}

	//生成机器常数文件
	if(input == 1)
	{
		STRUCT_write_MC_file(htmpbuf)	
	}

//    hnewWnd = NewWnd(htmpbuf)
	CloseBuf (htmpbuf)
	stop
	
}



/********************************************************************
*函数原型:
			macro STRUCT_write_MC_file(htmpbuf)
*参数说明:
            htmpbuf: 
            	由STRUCT_auto_parse生成的缓冲
*功能说明:
			将缓冲中的内容打印为机器常数配置文件
*返回值:
			无
********************************************************************/
macro STRUCT_write_MC_file(htmpbuf)
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

	var ch			//字符
	var hnewWnd		//新的窗口
	var unit		//打印方式，单位
	var input		//输入变量名
	var lay_num		//层数

	var str1
	var str2
	var MC_buf		//新的MC缓冲

	var input

	input = Ask ("输入机器常数文件名称")

	//取得htmpbuf的行
	ln_count = GetBufLineCount (htmpbuf)

	//建立缓冲
	MC_buf = NewBuf ("MC_buf")

	ln = 0

	AppendBufLine(MC_buf, "/***********************************************************/")
	AppendBufLine(MC_buf, "			机器常数配置文件，尽量不要手动修改!!!")
	AppendBufLine(MC_buf, "/***********************************************************/")
	AppendBufLine(MC_buf, "FILE_ID:0")
	AppendBufLine(MC_buf, "FILE_SIZE:0")
	AppendBufLine(MC_buf, "MACHINE_NUMBER:0")
	AppendBufLine(MC_buf, "VERSION_NUMBER:0")
	AppendBufLine(MC_buf, "SEQUENCE_NUMBER:0")
	AppendBufLine(MC_buf, "CHECK_SUM:0")
	AppendBufLine(MC_buf, "ALIGNMENT_TYPE:8")
	AppendBufLine(MC_buf, "/***********************************************************/{end}")

	AppendBufLine(MC_buf, "\#1<@input@> \@Group")

	while(ln < ln_count)
	{
		//取得缓冲中的某一行
		ln_text = GetBufLine(htmpbuf,ln);
		//解析取得内容
		data = STRUCT_parse_buf_line(ln_text)

		str1 = ""
		str2 = ""
		lay_num = data.layer_num ;
		//填写缩进
		while(lay_num > 0)
		{
			str1 = str1 # "\t";
			lay_num = lay_num - 1
		}

		//填写其他内容
		if(data.union == "struct")
		{
			str2 = "Group"
		}
		else
		{
			str2 = str2 # "DirectConstant %"
			str2 = str2 # data.type
			str2 = str2 # " !0 $ &"
		}

		AppendBufLine(MC_buf, str1 # "\#" # data.layer_num + 1 # "<" # data.variable # "> \@" # str2)
		ln = ln +1
	}
	//将MC_buf显示
    hnewWnd = NewWnd(MC_buf)
}

/********************************************************************
*函数原型:
			macro STRUCT_auto_printf(htmpbuf)
*参数说明:
            htmpbuf: 
            	由STRUCT_auto_parse生成的缓冲
*功能说明:
			将缓冲中的内容打印为printf格式的内容
*返回值:
			无
********************************************************************/
macro STRUCT_auto_printf(htmpbuf)
{
	var ln_count 	//缓冲长度
	var ln			//当前行
	var print_buf	//打印缓冲
	var string		//打印的变量字符串
	var data		//解析后的数据	
	var ln_text		//指定行的数据
	var cur_lay		//当前层数

	var diff		//指定行层数与当前层数之差

	var index 		//字符个数索引

	var ch			//字符
	var hnewWnd		//新的窗口
	var unit		//打印方式，单位
	var input		//输入变量

	ln_count = GetBufLineCount (htmpbuf)

	//建立打印缓冲
	print_buf = NewBuf ("print_buf")

	ln = 0
	cur_lay = 1


	input = Ask ("输入变量名称")

	while(ln < ln_count)
	{
		ln_text = GetBufLine(htmpbuf,ln);

		data = STRUCT_parse_buf_line(ln_text)

		//如果是struct,修正相应的string
		if(data.union == "struct")
		{
			//如果该项的层比当前层少或者相同
			if(data.layer_num <= cur_lay)
			{
				//计算出差了多少层
				diff = 	cur_lay - data.layer_num + 1	//如果两者相同，则需要减掉最后1个
				//如果没有差异 或者 累计字符为空
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

				//更新string内容，并把当前结构体的名称记录进去
				string = cat (string, data.variable # ".")
			}
			else
			{//如果是更深一层的结构体
				string = cat (string, data.variable # ".")
			}
			//记录当前的层数
			cur_lay = data.layer_num
		}
		else	 /*如果是子项，则将其记录*/
		{
			//判断层数，修改相应的string
			if(data.layer_num <= cur_lay)
			{
				//如果两者相同，则需要减掉最后1个
				diff = 	cur_lay - data.layer_num + 1	
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

			if(data.type == "float")
			{
				unit = "%f"
			}
			else if(data.type == "double")
			{
				unit = "%lf"			
			}
			else if(data.type == "char")
			{
				unit = "%c"			
			}
			else
			{
				unit = "%d"			
			}
			
			AppendBufLine(print_buf, "printf(\"" # input # "." # string # data.variable # "= " # unit # "\\n\"," #input # "." # string # data.variable # ");"
		}

		ln = ln+1
	}

    hnewWnd = NewWnd(print_buf)

}



/********************************************************************
*函数原型:
			STRUCT_auto_parse(htmpbuf, wnd_old, buf_old, ln_old, lay_num_old)
*参数说明:
            htmpbuf: 
            	用于存放结构体解析结果的缓冲，其每行的格式如下。
            	"~" + "层号" + "$" + "变量名称" + "!" + "变量类型" + "&" + "元素或者结构" + "*"	
			wnd_old:
				跳转之前的窗口句柄。
			buf_old:
				跳转前的缓冲。
			ln_old:
				跳转前的行号。
            lay_num_old
            	跳转前的层数。
*功能说明:
			解析当前的结构体，即光标所在位置的结构体。
*返回值:
			该宏将解析结果全部写入到htmpbuf当中，没有返回值。
********************************************************************/
macro STRUCT_auto_parse(htmpbuf, wnd_old, buf_old, ln_old, lay_num_old)
{
	var hbuf			//数据缓冲
	var hwnd			//窗口句柄
	var Selection		//选中范围
	var ln				//当前行号
	var ln_end			//当前结构体的结束行
	var rtn				//解析结构体中每一行的返回结果
	var struct_type		//结构体类型，判断是enum还是struct
	var wnd_sel			//选中区域

	var hbuf_new		//跳转后新的缓冲
	var hwnd_new		//跳转后新的窗口
	var ln_new			//跳转后新的行
	var index			//索引
	var lay_num			//层号
	var tmp_buf			//用于存放临时数据缓冲

	var dimension_tmp_buf	//用于存放维数
	var array_tmp_buff		//用于存放已经解析好的维数

	var ln_text			//取得某一行的内容
	var ln_text_len		//取得某一行的内容字符串的长度
	var find_flag		//判断是否找到
	var index_last		//索引
	var array_number	//数组维数

	var total_number	//数组的实际大小
	var act_arry_name	//数组实际维数的描述
	var temp_str		//临时字符串

	var hbuf_macro	//宏所在的缓冲
	var hwnd_macro	//宏所在的窗口
	var ln_macro	//宏所在的行


	//入口，层数增加
	lay_num = lay_num_old +1
	
	//取得当前窗口
	hwnd = GetCurrentWnd ( )
	if ( hwnd == 0 )
		stop
	//取得当前文件缓冲
	hbuf = GetCurrentBuf ( )

	//取得当前的选中范围
	Selection = GetWndSel (hwnd)
	ln = Selection.lnFirst +1
	ln_end = Selection.lnLast 
	
	//从第一行开始解析
	while(1)
	{
		//解析每一行
		rtn = STRUCT_parse_line(hbuf, ln)

		//如果是空行
		if(rtn == nil)
		{
			ln = ln+1
			continue
		}

		//如果是结构体结尾		
		if(rtn == "struct_end")
		{
			break;
		}

		//对数组处理，array_dimension表示数组维数
		if(rtn.array_dimension > 0) 
		{
			//开辟临时缓冲
			dimension_tmp_buf = NewBuf ("dimension_tmp_buf")
			array_tmp_buff = NewBuf ("array_tmp_buff")

			//将维数写入维数缓冲
			AppendBufLine(dimension_tmp_buf, rtn.array_dimension)

			//取得当前行内容
			ln_text = GetBufLine(hbuf, ln)	
			find_flag = IchInString(ln_text, ";")
			ln_text = strmid(ln_text, 0, find_flag)
			//当前行取得字符串
			ln_text_len = strlen(ln_text)

			//查找数组的维数			
			index = 0
			while(index < ln_text_len)
			{
				if(ln_text[index] == "[")
				{
					index = index + 1
					//抛弃空字符
					while(ln_text[index] == " " || ln_text[index] == "\t") 
					{
						index = index + 1
					}
					//此时index为数组维数的首个字符索引

					//查找维数得结束
					index_last = index
					while(ln_text[index_last] != " " && ln_text[index_last] != "\t" && ln_text[index_last] != "]")
					{

						index_last = index_last + 1
					}
					//此时index_last为数组维数的首个字符索引
			
					//得到维数
					array_number = strmid(ln_text, index, index_last)

					//判断层数是数字还是宏
					if(IsNumber(array_number) == TRUE)/*如果层数是数字*/
					{
						AppendBufLine(dimension_tmp_buf, "@array_number@")
					}
					else	/*如果层数是宏*/
					{
						//设定跳转点
						SetBufIns (hbuf, ln, index)

						//跳转
						Jump_To_Base_Type

						//取得当前的wnd_sel
						hwnd_macro = GetCurrentWnd ( )//取得宏所在的窗口
						if ( hwnd_macro == 0 )
							stop
						hbuf_macro= GetCurrentBuf ( )//取得宏所在的文件缓冲
						ln_macro = GetWndSelLnFirst (hwnd_macro)	//取得宏所在的行号

						//查找源数据,将宏定义转换成数据.
						array_number = STRUCT_mcaro_to_number(hwnd_macro, hbuf_macro, ln_macro)
						//将维数写入维数缓冲
						AppendBufLine(dimension_tmp_buf, "@array_number@")
	
						//返回原来的窗口
						SetCurrentWnd (hwnd)
						//返回原来的缓冲
						SetCurrentBuf (hbuf)
						//设定焦点
						SetBufIns (hbuf, ln, index)
					}
				
				}

				index = index + 1
			}

			//将其转换成需要得格式,写入array_tmp_buff,其格式如下
			//[0][0][0],....,
			//[0][0][1]
			//....
			//[i-1],[j-1],[k-1]
			
			total_number = STRUCT_write_array_format(dimension_tmp_buf, array_tmp_buff)

			//变量名称
			temp_str = rtn.variable

			//将该数组整理，写入到htmpbuf当中
			index = 0
			while(index < total_number)
			{
				//取得数组后缀字符串，格式为[i-1],[j-1],[k-1]
				act_arry_name = GetBufLine(array_tmp_buff, index)

				//将其添加到变量后边
				rtn.variable = temp_str # act_arry_name

				//判断数组的类型是基本类型还是非基本类型
				if(rtn.type == "int" || rtn.type == "double" ||rtn.type == "float" || rtn.type == "SMEE_BOOL" || rtn.type == "short" || rtn.type == "char")
				{
					//将其按格式写入到缓冲当中
					AppendBufLine(htmpbuf,"~" # lay_num # "$" # rtn.variable # "!" # rtn.type # "&" # "element" # "*")
				}
				else	//如果不是基本类型
				{
					//设定跳转的位置
					SetBufIns (hbuf, ln, rtn.firstCh+1)
					//跳转
					Jump_To_Base_Type	

					//取得新的窗口
					hwnd_new= GetCurrentWnd ( )
					if ( hwnd_new== 0 )
						stop
					//取得新的文件缓冲
					hbuf_new= GetCurrentBuf ( )

					//取得新的的行号
					ln_new = GetWndSelLnFirst (hwnd_new)	
					//取得选中区域
					wnd_sel = GetWndSel (hwnd_new)
					tmp_buf =GetBufLine (hbuf_new, ln_new)
					struct_type = strmid (tmp_buf, wnd_sel.ichFirst, wnd_sel.ichLim)
					//取得类型
					if(struct_type == "enum")	/*如果是枚举，按照基本类型处理*/
					{
						//跳转回去
						Go_Back
						//写入htmpbuf
						AppendBufLine(htmpbuf, "~" # "@lay_num@" # "$" # rtn.variable # "!" # rtn.type # "&" # "element" # "*")
					}

					//如果是结构体，循环解析
					if(struct_type == "struct")			
					{
						//写入htmpbuf
						AppendBufLine(htmpbuf, "~" # "@lay_num@" # "$" # rtn.variable # "!" # rtn.type # "&" # "struct" # "*")
						//继续解析
						STRUCT_auto_parse(htmpbuf, hwnd, hbuf, ln, lay_num)
					}
				}	
				index = index + 1
			}

			//关闭数组临时缓冲
			CloseBuf (dimension_tmp_buf)
			CloseBuf (array_tmp_buff)
		}
		else//不是数组
		{
			//判断是否是基本类型
			if(rtn.type == "int" || rtn.type == "double" ||rtn.type == "float" || rtn.type == "SMEE_BOOL" || rtn.type == "short" || rtn.type == "char")
			{
				//将其按格式写入到缓冲当中
				AppendBufLine(htmpbuf,"~" # lay_num # "$" # rtn.variable # "!" # rtn.type # "&" # "element" # "*")
			}
			else	//如果不是基本类型
			{
				//设定跳转的位置
				SetBufIns (hbuf, ln, rtn.firstCh+1)

				//跳转
				Jump_To_Base_Type	

				//取得新的窗口
				hwnd_new= GetCurrentWnd ( )
				if ( hwnd_new== 0 )
					stop

				//取得新的文件缓冲
				hbuf_new= GetCurrentBuf ( )

				//取得新的行号
				ln_new = GetWndSelLnFirst (hwnd_new)	

				//取得选中区域
				wnd_sel = GetWndSel (hwnd_new)

				//取得该行字符串
				tmp_buf =GetBufLine (hbuf_new, ln_new)

				//取得类型
				struct_type = strmid (tmp_buf, wnd_sel.ichFirst, wnd_sel.ichLim)

				//如果是枚举
				if(struct_type == "enum")
				{
					//跳转回去
					Go_Back

					//写入htmpbuf
					AppendBufLine(htmpbuf, "~" # "@lay_num@" # "$" # rtn.variable # "!" # rtn.type # "&" # "element" # "*")
				}

				//如果是结构体，循环解析
				if(struct_type == "struct")			
				{
					//写入htmpbuf
					AppendBufLine(htmpbuf, "~" # "@lay_num@" # "$" # rtn.variable # "!" # rtn.type # "&" # "struct" # "*")
					//继续解析
					STRUCT_auto_parse(htmpbuf, hwnd, hbuf, ln, lay_num)
				}
			}		
		}
		//行号++
		ln = ln+1
	}

 	//出口
	lay_num = lay_num +1

	//返回原来的窗口
	SetCurrentWnd (wnd_old)
	//返回原来的缓冲
	SetCurrentBuf (buf_old)
	//返回原来的行，第一列	
	SetBufIns (buf_old, ln_old, 0)
}


/********************************************************************
*函数原型:
			macro STRUCT_parse_line(cur_buf, ln)
*参数说明:
            cur_buf: 
            	指定的缓冲
            ln:
            	制定的行
*功能说明:
			解析缓冲中的指定行，并返回结果。
*返回值:
			switch(指定行的字符串)
			{
				case 空行:
				case 空字符行:
				case "{":
				case 被注释掉的行:
				case 没有找到";"
					return nil
				case "}"
					return "struct_end"
				default:	//正常情况
					data.variable //变量名称
					data.type //变量类型
					data.firstCh	//变量名称的第一个字符
					data.array_dimension //变量维数
					return data.
			}
********************************************************************/
macro STRUCT_parse_line(cur_buf, ln)//判断纯粹的有意义行，不包括 { }等
{
	var sz_text //当前行内容
	var index	//索引
	var len		//字符串长度
	var find_flag	//找到的标志
	var file_name //文件名称

	var data	//返回的结果数据

	var first_ch	//第一个非空字符
	var last_ch		//最后一个字符

	var step_flag	//0 找类型，1 找变量

	var array_dimension	//数组的维数,即查到"["的次数;

	//将数组维数指定为0，默认不是数组
	array_dimension = 0
	
	//取得指定行内容
	sz_text = GetBufLine(cur_buf,ln)	

	//取得字符串长度
	len = strlen(sz_text)

	//判断本行是否为空
	if(len == 0)
	{
		//返回空结果
		data = nil;
		return data
	}

	//判断本行是否全部为空格或者tab
	index = 0
	while(sz_text[index] == " " || sz_text[index] == "\t")
	{
		index = index + 1
		if(index == len)
		{
			//返回空结果
			data = nil;
			return data
		}
	}

	//如果本行注释掉了，第一个字符为'/'
	if(sz_text[index] == "/")
	{
			//返回空结果
			data = nil;
			return data
	}
	
	//这时index为第一个不为空的字符

	//如果找到"}",结构体结束
	find_flag = IchInString(sz_text, "{")
	if(find_flag >= 0)
	{
		//返回空结果
		data = nil;
		return data
	}

	//如果找到"{"
	find_flag = IchInString(sz_text, "}")
	if(find_flag >= 0)
	{
		//返回结束字符
		data = "struct_end";
		return data
	}
	
	//如果找到分号,说明本行有效
	find_flag = IchInString(sz_text, ";")

	//如果没有找到，本行按照空行处理
	if(find_flag < 0)
	{
		file_name = GetBufName (cur_buf)	
		data = nil
		return data
	}

	//查找类型名称字符串
	first_ch = index
	step_flag = 0
	while(index < len && sz_text[index] != " " && sz_text[index] != "\t")
	{
		index = index +1
	}
	last_ch = index

	//取得类型名
	data.type = strmid(sz_text , first_ch, last_ch)	

	//如果是"unsigned",则需再次查找类型名
	if(data.type == "unsigned")
	{
		//抛弃空字符
		while(sz_text[index] == " " || sz_text[index] == "\t")
		{
			index = index + 1
		}

		//继续查找类型
		first_ch = index
		step_flag = 0
		while(index < len && sz_text[index] != " " && sz_text[index] != "\t")
		{
			index = index +1
		}
		last_ch = index
	
		//取得类型名
		data.type = strmid(sz_text , first_ch, last_ch)		
	}

	//抛弃空字符
	while(sz_text[index] == " " || sz_text[index] == "\t")
	{
		index = index + 1
	}

	//查找变量名
	while(sz_text[index] == " " || sz_text[index] == "\t")
	{
		index = index + 1
	}

	first_ch = index
	
	while(index < len && sz_text[index] != " " && sz_text[index] != "\t" && sz_text[index] != ";" && sz_text[index] != "[")
	{
		index = index +1
	}
	last_ch = index
	
	data.variable = strmid(sz_text , first_ch, last_ch)	

	data.firstCh = first_ch

	//查找数组维数,如果为0,则不是数组
	array_dimension = Find_times_occured(strmid(sz_text , 0, find_flag),"[")

	data.array_dimension = array_dimension

	return data
}



/********************************************************************
*函数原型:
			macro STRUCT_parse_line(cur_buf, ln)
*参数说明:
            cur_buf: 
            	指定的缓冲
            ln:
            	指定的行
*功能说明:
			将结构体中得宏转换成为数字
*返回值:
			已经转换后的数字
********************************************************************/
macro STRUCT_mcaro_to_number(hwnd_macro, hbuf_macro, ln_macro)
{

	var macro_sel	//宏选中得区域
	var sz_text		//字符串
	var find_flag	//字符串搜索结果
	var Result		//宏所代表得数值
	var index		//索引
	var len			//字符串长度
	var index_first	
	var index_last
	var find_flag2
	var ln_step		//光标向上移动的次数
	var up_step		//枚举改变的次数

	Result = ""
	up_step = 0
	ln_step = 0
	
	//选中宏所在得行
	sz_text = GetBufLine (hbuf_macro, ln_macro)

	//判断sz_text中是否存在 define 字符串
	find_flag = FindString(sz_text , "#define")

	if(find_flag == "X")	//说明是枚举
	{

		while(1)//循环查找
		{
			//取得该行数据
			sz_text = GetBufLine (hbuf_macro, ln_macro - ln_step)
			len = strlen(sz_text)

			ln_step = ln_step + 1	/*向上移动一次*/


			//判断本行是否全部为空格或者tab
			index = 0
			while(sz_text[index] == " " || sz_text[index] == "\t")
			{
				index = index + 1
				if(index == len)	//如果是空行,则跳出本循环
				{
					break;
				}
			}

			if(index == len)	//如果是空行,则继续下一行
			{
				continue
			}

			//如果本行注释掉了
			if(sz_text[index] == "/")
			{
				continue
			}
			
			//如果判断是"{"
			if(sz_text[index] == "{")	//如果找到了枚举的起始点
			{
				Result = up_step -1
				break;
			}

			//将注释部分过滤
			find_flag2 = IchInString(sz_text, "/")
			if(find_flag2 > 0)	//如果说存在注释
			{
				sz_text = strmid(sz_text, 0, find_flag2)
				len = strlen(sz_text)
			}	

			//查找是否存在"=",如果存在"=",则可以一次提取
			find_flag2 = IchInString(sz_text, "=")
			if(find_flag2 > 0)
			{
				index = find_flag2 +1
				//过滤空格
				while(sz_text[index] == " " || sz_text[index] == "\t")
				{
					index = index + 1
					if(index == len)
					{
						Msg("错误得宏定义,行=" # ln_macro)
						stop
					}
				}

				index_first = index

				//取得非空字符
				while(index <len && sz_text[index] != " " && sz_text[index] != "\t" && sz_text[index] != ",") 
				{
					index = index +1
				}	

				Result = strmid(sz_text, index_first, index)

				//如果所得结果不是数字
				if(IsNumber(Result) != TRUE)
				{
						Msg("错误得宏定义,行=" # ln_macro)
						stop
				}

				Result = Result + up_step 
					
				break
			}

			//枚举数加1
			up_step = up_step + 1
		}

	}
	else	//说明是宏定义
	{
		//取得字符串长度
		len = strlen(sz_text)

		//取得宏所在得区域
		macro_sel = GetWndSel (hwnd_macro)

		//找出最后一个字符得索引
		index = macro_sel.ichLim + 1

		//去除空格,tab
		while(sz_text[index] == " " || sz_text[index] == "\t")
		{
			index = index +1			
			if(index == len)
			{
				Msg("错误得宏定义,行=" # ln_macro)
				stop
			}
		}

		//找到第一个非空字符
		index_first = index

		//取得非空字符
		while(index <len && sz_text[index] != " " && sz_text[index] != "\t" && sz_text[index] != "/") 
		{
			index = index +1
		}			

		Result = strmid(sz_text, index_first, index)

		//如果所得结果不是数字
		if(IsNumber(Result) != TRUE)
		{
				Msg("错误得宏定义,行=" # ln_macro)
				stop
		}

	}

	return Result
}

/********************************************************************
*函数原型:
			macro STRUCT_parse_line(cur_buf, ln)
*参数说明:
            src_buf: 
            	源缓冲，
            dest_buf:
            	目标缓冲
*功能说明:
			将src中得内容按照格式写入destbuf，格式如下
			//[0][0][0],....,
			//[0][0][1]
			//....
			//[i-1],[j-1],[k-1]
*返回值:
			所有维数之积
********************************************************************/
macro STRUCT_write_array_format(src_buf, dest_buf)
{
	var ln_count	//源buf得行数
	var cur_ln		//当前行

	var total_number	//所有得维数之积
	var temp_number	
	var index			//索引
	var temp_str		//临时字符串

	var remainder	//余数
	var result		//除后得结果

	var hnewWnd
	var div_result	//除数结果


	total_number = 1


	//取得源buf得行数	
	ln_count = GetBufLineCount (src_buf)

	//从后往前索引，先算出所有得维数之积
	cur_ln = ln_count - 1
	while(cur_ln > 0)
	{
		temp_number = GetBufLine(src_buf , cur_ln)
		total_number = total_number * temp_number
		cur_ln = cur_ln -1
	}

	//将这些数据按格式写
	index = 0
	while(index < total_number)
	{
		result = index
		temp_str = ""
		//根据源缓冲中的数据相除
		cur_ln = ln_count - 1
		while(cur_ln > 0)
		{
			//取得原缓冲中的数据
			temp_number = GetBufLine(src_buf , cur_ln)
			//取得除数
			div_result = result / temp_number
			//取得余数
			remainder = result - (div_result * temp_number)//求余数
			//将余数保存
			temp_str = "[" # remainder # "]" # temp_str
			//更新结果数据
			result = div_result 
			//原缓冲增加
			cur_ln = cur_ln - 1
		}
		//将结果记录到目标缓冲
		AppendBufLine(dest_buf, temp_str)
		//索引增加
		index = index +1
	}

	return total_number
}

/********************************************************************
*函数原型:
			macro STRUCT_parse_buf_line(ln_text)
*参数说明:
            ln_text: 
            	结构体解析后的临时缓冲中的一行数据，其格式如下:
			"~" + "层号" + "$" + "变量名称" + "!" + "变量类型" + "&" + "元素或者结构" + "*"
*功能说明:
			将临时缓冲中的一行数据解析
*返回值:
			如果是空行返回nil，
			否则返回data，格式如下
			data.layer_num 层号		
			data.variable 变量名称
			data.type 变量类型
			data.union 变量是否式结构体的标志
********************************************************************/
macro STRUCT_parse_buf_line(ln_text)
{
	var data		//数据结果
	var index		//索引
	var index_first	//首字符索引
	var index_last	//末字符索引
	var ch			//字符

	if(ln_text == nil)
	{
		return nil	
	}

	index = 0
	ch = ln_text[index]
	while(ch != "~")
	{
		ch = ln_text[index]
		index = index +1
	}

	//查找层数
	index_first = index+1
	while(ch != "$")
	{
		ch = ln_text[index]
		index = index +1
	}
	index_last = index	
	data.layer_num = strmid(ln_text,index_first, index_last-1)

	//查找变量名称
	index_first = index
	while(ch != "!")
	{
		ch = ln_text[index]
		index = index +1
	}
	index_last = index	
	data.variable = strmid(ln_text,index_first, index_last-1)

	//查找变量类型
	index_first = index
	while(ch != "&")
	{
		ch = ln_text[index]
		index = index +1
	}
	index_last = index	
	data.type = strmid(ln_text,index_first, index_last-1)

	//查找是struct

	index_first = index
	while(ch != "*")
	{
		ch = ln_text[index]
		index = index +1
	}
	index_last = index	
	data.union = strmid(ln_text,index_first, index_last-1)

	return data

}



