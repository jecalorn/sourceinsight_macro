
/********************************************************************
			取得系统日期
********************************************************************/
macro GetCurDataTime ( )
{
	var szTime
	var sz

	szTime = GetSysTime ( 1 )

	if (szTime.Month < 10)
		szTime.Month = 0 # szTime.Month;
	if (szTime.Day < 10)
		szTime.Day = 0 # szTime.Day;
	if (szTime.Hour < 10)
		szTime.Hour = 0 # szTime.Hour;
	if (szTime.Minute < 10)
		szTime.Minute = 0 # szTime.Minute;
	sz = szTime.Year # "-" # szTime.Month # "-" # szTime.Day 
//	# ", "
//		# szTime.Hour # ":" # szTime.Minute

	return sz
}


/********************************************************************
			判断字符串s中是否有字符ch.
********************************************************************/
macro IchInString(s, ch)
{
    i = 0
    cch = strlen(s)
    while (i < cch)
        {
        if (s[i] == ch)
            return i
        i = i + 1
        }

    return (0-1)
}



/********************************************************************
			判断字符串source中是否存在子字符串target.
********************************************************************/
macro FindString ( source, target )
{
	var source_len
	var target_len
	var match
	var cp
	var k
	var j

	source_len = strlen ( source )
	target_len = strlen ( target )

	match = 0
	cp = 0

	while( cp < source_len )
	{
		while( cp < source_len )
		{
			if( source[cp] == target[0] )
				break
			else
				cp = cp + 1
		}

		if( cp == source_len )
			break;

		k = cp
		j = 0
		while( j < target_len && source[k] == target[j] )
		{
			k = k + 1
			j = j + 1
		}

		if (j == target_len)
		{
			match = 1
			break
		}

		cp = cp + 1
	}

	if( match )
		return cp
	else
		return "X"
}


/********************************************************************
			查找字符串ch在字符串str中出现的次数。
********************************************************************/

Macro Find_times_occured(str, ch)
{
    var i
    var cch
	var result

    i = 0
	result = 0
    cch = strlen(str)
    while (i < cch)
    {
	    if (str[i] == ch)
	    {
	    	result = result + 1
	    }
	    i = i + 1
    }

    return (result)
}




/********************************************************************
			将选中的内容注释掉
********************************************************************/
macro CommentBlock ( )
{
	var hwnd
	var hbuf
	var sel

	var ln
	var hit
	var len

	var cur_line

	// get window, sel, and buffer handles
	hwnd = GetCurrentWnd ( )
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )
	sel = GetWndSel ( hwnd )
	ln = sel.lnFirst

	if ( ln == sel.lnLast )
	{
		cur_line = cat ( "//", GetBufLine ( hbuf, ln ) )
		DelBufLine ( hbuf, ln )
		InsBufLine ( hbuf, ln, cur_line )
		SetBufIns ( hbuf, ln, sel.ichLim + 2 );
		stop
	}

	hit = 0

	while ( ln <= sel.lnLast )
	{
		cur_line = GetBufLine ( hbuf, ln )
		len = strlen ( cur_line )
		if ( len > 0 )
		{
			cur_line = cat ( "//", cur_line )
			DelBufLine ( hbuf, ln )
			InsBufLine ( hbuf, ln, cur_line )
			hit = 1
		}
		ln = ln + 1
	}

	// Not perfect, but this work most of the time
	if ( hit == 1 )
	{
		sel.ichFirst = 0
		sel.ichLim = sel.ichLim + 2
	}

	SetWndSel ( hwnd, sel )
}

/********************************************************************
			将选中的注释取消
********************************************************************/
macro UncommentBlock ( )
{
	var hwnd
	var hbuf
	var sel

	var ln
	var hit
	var len

	var cur_line
	var new_line

	// get window, sel, and buffer handles
	hwnd = GetCurrentWnd ( )
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )
	sel = GetWndSel ( hwnd )
	ln = sel.lnFirst

	if ( ln == sel.lnLast )
	{
		cur_line = GetBufLine ( hbuf, ln )
		len = strlen ( cur_line )
		if ( len > 0 )
		{
			if ( ( cur_line[0] == "/" ) && ( cur_line[1] == "/" ) )
			{
				new_line = strmid ( cur_line, 2, len )
				DelBufLine ( hbuf, ln )
				InsBufLine ( hbuf, ln, new_line )
				SetBufIns ( hbuf, ln, sel.ichLim - 2 )
			}
		}
		stop
	}

	hit = 0

	while ( ln <= sel.lnLast )
	{
		cur_line = GetBufLine ( hbuf, ln )
		len = strlen ( cur_line )
		if ( len > 0 )
		{
			if ( ( cur_line[0] == "/" ) && ( cur_line[1] == "/" ) )
			{
				new_line = strmid ( cur_line, 2, len )
				DelBufLine ( hbuf, ln )
				InsBufLine ( hbuf, ln, new_line )
				hit = 1
			}
		}
		ln = ln + 1
	}

	// Not perfect, but this work most of the time
	if (hit == 1)
	{
		sel.ichLim = sel.ichLim - 2
	}
	SetWndSel ( hwnd, sel )
}

/********************************************************************
			删除本文件中的空行，注意，需要多次执行
********************************************************************/
Macro Delete_blank_line()
{
	var hbuf			//数据缓冲
	var hwnd			//窗口句柄
	
	hwnd = GetCurrentWnd ( )//取得当前窗口
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//取得当前文件缓冲

	Blank_Line_Down

	Delete_Line
	
	Top_of_File

	stop
}

/********************************************************************
			当前位置插入一条注释分割线
********************************************************************/
macro Add_Line_comment()
{
	var hwnd
	var hbuf
	var ln
	var input
	var str_len
	var len
	var str

    hwnd = GetCurrentWnd( )     // 取得当前窗口
    if(hwnd == 0)
        stop
    hbuf = GetCurrentBuf( )     // 取得当前文件缓冲

	ln = GetWndSelLnFirst (hwnd)	//取得当前的行号

	input = ask("0-头文件包含; 1-外部函数声明; 2-内部函数声明; 3-全局数据定义; 4-外部数据声明; 5-函数定义; 6-数据结构定义; 7-其他")

	if(input == 0)
	{
		input = "头文件包含"
	}
	else if(input == 1)
	{
		input = "外部函数声明"
	}
	else if(input == 2)
	{
		input = "内部函数声明"	
	}
	else if(input == 3)
	{
		input = "全局数据定义"	
	}
	else if(input == 4)
	{
		input = "外部数据声明"	
	}
	else if(input == 5)
	{
		input = "函数定义"	
	}
	else if(input == 6)
	{
		input = "数据结构定义"	
	}
	else if(input == 7)
	{
		input = ask("输入")
	}


	len = strlen(input)

	str_len = 80 - len

	str_len = str_len - 18

	str	= ""
	while(str_len > 1)
	{
		str = str # "-"
		str_len = str_len -1
	}

	Insert_Line SetBufSelText ( hbuf, "/*--------------" # input # str # "*/")

	stop

}

/********************************************************************
			将光标停留在函数声明处，刷出代码和函数头注释
********************************************************************/
macro Creat_function()
{
	var hbuf			//数据缓冲
	var hwnd			//窗口句柄
	var ln				//行号
	var sz_func_name	//函数名称字符串
	var cch				//字符
	var ch
	var sz_text			//字符串
	var index			//索引
	var module_name		//模块名称
	var layer_name		//层次名称
	var len				//字符串长度
	var lnFirst
	var all_name		//函数名全程

	
	hwnd = GetCurrentWnd ( )//取得当前窗口
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//取得当前文件缓冲


	ln = GetWndSelLnFirst (hwnd)	//取得当前的行号

	cch='('						

	sz_text=GetBufLine(hbuf,ln)	//取得当前行内容
	all_name = sz_text
	len = strlen(sz_text)
	sz_text = strmid(sz_text, 4 ,len)//去掉 int RT

	//取得函数名称
	index=0
	ch=sz_text[index]
	while(ch!="(")
	{
		index=index+1
		ch=sz_text[index]
	}
	sz_func_name=strtrunc (sz_text,index)	//取得函数名
	module_name=strtrunc(sz_text,2)	//取得模块明

	module_name = toupper(module_name)


	index=0
	ch=sz_text[index]
	while(ch!="_")
	{
		index=index+1
		ch=sz_text[index]
	}
	layer_name= strtrunc (sz_text,index)	//取得层次名
	layer_name = toupper(layer_name)
	
	Insert_Line SetBufSelText ( hbuf, "/********************************************************************")
	Insert_Line_Before_Next SetBufSelText ( hbuf, "*头文件:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <RT4A_types.h> <RT4T_types.h> <RTMC.h> <" # layer_name # ".h>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*函数原型:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            "# all_name)
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*输入参数:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <无>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*输出参数:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <无>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*输入输出:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <无>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*返回值:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            - OK")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*功能描述:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <无>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*数据结构:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <无>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*前置条件:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <无>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*后置条件:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <无>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*伪代码:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <无>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "********************************************************************/")	

	Cursor_Down			//光标下移一行


	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "    int error_code = OK;")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "int link_error[2] = {0, 0};")	

	Insert_Line_Before_Next SetBufSelText ( hbuf, "char *func_name = \"" # sz_func_name # "\";")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "char *error_str = NULL;")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "char *infor_str = NULL;")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "char *RTER_name = NULL;")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "char *RTER_text = NULL;")


	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "/*入口参数跟踪*/")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "if("# layer_name # "_TRACING_IS_ON == SMEE_TRUE)")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")
	
	Insert_Line_Before_Next Indent_Right SetBufSelText ( hbuf, "RTSPDB_TR_trace(func_name, RTSPDB_TRACE_IN, \">()\");")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")


	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "/*出口参数跟踪*/")
	Insert_Line_Before_Next SetBufSelText ( hbuf, "if("# layer_name # "_TRACING_IS_ON == SMEE_TRUE)")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")


	Insert_Line_Before_Next Indent_Right SetBufSelText ( hbuf, "error_str = \"OK\";")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "if(error_code != 0)")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")	
	Insert_Line_Before_Next Indent_Right SetBufSelText ( hbuf, "error_str = \"ERROR\";")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")


	
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "RTSPDB_TR_trace(func_name, RTSPDB_TRACE_OUT, \"<()=%s\",error_str);")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "return error_code;")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")

	stop	

}

/********************************************************************
			在文件的顶部刷出文件头说明
********************************************************************/
macro Creat_file_head()
{
	var hbuf			//数据缓冲
	var hwnd			//窗口句柄
	var ln				//行号
	var sz_func_name	//函数名称字符串
	var cch				//字符
	var ch
	var sz_text			//字符串
	var index			//索引
	var module_name		//模块名称
	var file_name		//文件名称
	var len				//字符串长度
	var cc_name			//组件名称
	var lnFirst
	var all_name		//函数名全程
	var time			// 当前时间

	
	hwnd = GetCurrentWnd ( )//取得当前窗口
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//取得当前文件缓冲

	file_name = GetBufName (hbuf) //取得文件名称


	//取得组件名称
	index=strlen(file_name)
	ch=file_name[index]
	while(ch!="\\")
	{
		index=index-1
		ch=file_name[index]
	}
	index = index + 1
	len = strlen(file_name)
	file_name = strmid(file_name, index , len)

	index=0
	ch=file_name[index]
	while(ch!=".")
	{
		index=index+1
		ch=file_name[index]
	}
	
	
	cc_name=strtrunc(file_name,2)	//取得模块明

	module_name=strtrunc (file_name,index)	//取得模块
	time = GetCurDataTime()


	ln = 0
	InsBufLine ( hbuf, ln, "/**************************************************************************" )
	InsBufLine ( hbuf, ln + 1, "* Copyright (C) 2000--2100, " )
	InsBufLine ( hbuf, ln + 2, "* All rights reserved." )
	InsBufLine ( hbuf, ln + 6, "* 文件名称 : " # file_name )
	InsBufLine ( hbuf, ln + 7, "* 概要描述 : ")
	InsBufLine ( hbuf, ln + 8, "* 历史记录 : " )
	InsBufLine ( hbuf, ln + 9, "* 版本    日期         作者        内容" )
	InsBufLine ( hbuf, ln + 10, "* V1.0   " # time  # "    Belife      创建文件")	
	InsBufLine ( hbuf, ln + 11, "**************************************************************************/" )

	stop

}







/********************************************************************
			刷出整个文件的ifdefine
********************************************************************/
macro Creat_if_define()
{
	var hbuf			//数据缓冲
	var hwnd			//窗口句柄
	var file_name		//文件名称
	var len
	var index


	hwnd = GetCurrentWnd ( )//取得当前窗口
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//取得当前文件缓冲

	file_name = GetBufName (hbuf) //取得文件名称

	len = strlen(file_name) 

	msg(len);

	index = len - 1

	while(index != 0 && file_name[index] != "\\")
	{
		index = index -1
	}

	file_name = strmid(file_name, index + 1, len)

	len = strlen(file_name)

	index = 0

	while(index < len)
	{
		if(file_name[index] == ".")
		{
			file_name[index] = "_"
		}
		else
		{
			if(islower (file_name[index]))
			{
				file_name[index] = toupper (file_name[index])
			}
		}

		index = index + 1
	}

	file_name = "__" # file_name # "_"

	SetBufIns (hbuf, 0, 0)

	Insert_Line SetBufSelText(hbuf, "#ifndef " # file_name)
	Insert_Line_Before_Next SetBufSelText(hbuf, "#define " # file_name)



	SetBufIns (hbuf, GetBufLineCount (hbuf) -1, 0)
	Insert_Line_Before_Next SetBufSelText(hbuf, "#endif //end of" # file_name)

	msg(file_name);


}



