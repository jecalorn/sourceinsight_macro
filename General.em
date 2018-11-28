/**************************************************************************
* Copyright (C) 2007, 上海微电子装备有限公司
* All rights reserved.
* 产品号 : SS B500/10
* 所属组件 : General.em
* 模块名称 : General.em
* 文件名称 : General.em
* 概要描述 : 本文件主要集中了通用操作相关操作的宏。
* 历史记录 : 
* 版本    日期         作者        内容
* V1.0   2007-06-07    张方元      创建文件
**************************************************************************/

/*--------------V1.0---------------------------------------------------------*/
//V1.0
//根据以前的各种宏整理出如下内容,有一部分是liuj编写
//
//1	-	注释选中块
//2	-	取消块的注释
//3	-	增加注释分割线
//4	-	创建错误处理代码
//5	-	创建正常处理代码
//6	-	根据函数声明刷出函数头注释和部分代码
//7	-	刷出文件头注释
//8	-	根据函数声明刷出测试函数
//9	-	根据函数声明刷出2级仿真函数(IO)
//10-	删除文件中的空行
//11-	抽取函数头注释，使之形成文档




/********************************************************************
*函数原型:
			macro GetCurDataTime ( )
*参数说明:
			无
*功能说明:
			取得系统日期
*返回值:
			系统时间
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
*函数原型:
			macro IchInString(s, ch)
*参数说明:
			s:
				需要查找的字符串。
			ch:
				查找的目标字符。
*功能说明:
			判断字符串s中是否有字符ch.
*返回值:
			如果在字符串s中找到了ch，则返回实际位置，如果没有找到返回-1
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
*函数原型:
			macro FindString ( source, target )
*参数说明:
			source:
				源字符串。
			target:
				目标字符串。
*功能说明:
			判断字符串source中是否存在子字符串target.
*返回值:
			如果在字符串source中找到了target，则返回实际位置，
			如果没有找到返回"X"
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
*函数原型:
			Macro Find_times_occured(str, ch)
*参数说明:
			str:
				源字符串。
			ch:
				目标字符
*功能说明:
			查找字符串ch在字符串str中出现的次数。
*返回值:
			出现的次数。
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
*函数原型:
			macro CommentBlock ( )
*参数说明:
			无
*功能说明:
			将选中的内容注释掉
*返回值:
			无
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
*函数原型:
			macro UncommentBlock ( )
*参数说明:
			无
*功能说明:
			将选中的注释取消
*返回值:
			无
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
*函数原型:
			Macro Delete_blank_line()
*参数说明:
			无
*功能说明:
			删除本文件中的空行，注意，需要多次执行
*返回值:
			无
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
*函数原型:
			macro Add_Line_comment()
*参数说明:
			无
*功能说明:
			当前位置插入一条注释分割线
*返回值:
			无
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
*函数原型:
			macro Creat_function()
*参数说明:
			无
*功能说明:
			将光标停留在函数声明处，刷出代码和函数头注释
*返回值:
			无
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
*函数原型:
			macro Creat_file_head()
*参数说明:
			无
*功能说明:
			在文件的顶部刷出文件头说明
*返回值:
			无
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
	InsBufLine ( hbuf, ln + 1, "* Copyright (C) 2007, 上海微电子装备有限公司" )
	InsBufLine ( hbuf, ln + 2, "* All rights reserved." )
	InsBufLine ( hbuf, ln + 3, "* 产品号 : SS B500/10" )
	InsBufLine ( hbuf, ln + 4, "* 所属组件 : " # cc_name )
	InsBufLine ( hbuf, ln + 5, "* 模块名称 : " # module_name)
	InsBufLine ( hbuf, ln + 6, "* 文件名称 : " # file_name )
	InsBufLine ( hbuf, ln + 7, "* 概要描述 : ")
	InsBufLine ( hbuf, ln + 8, "* 历史记录 : " )
	InsBufLine ( hbuf, ln + 9, "* 版本    日期         作者        内容" )
	InsBufLine ( hbuf, ln + 10, "* V1.0   " # time  # "    张方元      创建文件")	
	InsBufLine ( hbuf, ln + 11, "**************************************************************************/" )

	stop

}


/********************************************************************
*函数原型:
			Macro Creat_error_log()
*参数说明:
			无
*功能说明:
			在当前位置刷出错误处理代码
*返回值:
			无
********************************************************************/
Macro Creat_error_log()
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
	var input

	
	hwnd = GetCurrentWnd ( )//取得当前窗口
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//取得当前文件缓冲

	input = Ask("0-不带参数的错误；1-带参数的错误; 2-参数错误");

	if(input == 0)
	{
		Insert_Line_Before_Next SetBufSelText ( hbuf, "if(error_code != OK)")
		Insert_Line_Before_Next SetBufSelText ( hbuf, "{")	
		Insert_Line_Before_Next SetBufSelText ( hbuf, "    link_error[0] = error_code;")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "link_error[1] = 0;")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "error_code = RT_ERROR_XXXX;")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "RTER_name = RTSPER_name(error_code);")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "RTER_text = RTSPER_text(error_code);")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "error_str = RTSPDB_EH_creat_text(\"%s\\n[%s:%s]\", RTER_text, func_name, RTER_name);")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "RTSPDB_EH_log_error(error_code, link_error, error_str, __FILE__, __LINE__);")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "free(error_str);")		
		Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")		
	}

	if(input == 1)
	{
		Insert_Line_Before_Next SetBufSelText ( hbuf, "if(error_code != OK)")
		Insert_Line_Before_Next SetBufSelText ( hbuf, "{")	
		Insert_Line_Before_Next SetBufSelText ( hbuf, "    link_error[0] = error_code;")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "link_error[1] = 0;")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "error_code = RT_ERROR_XXXX;")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "infor_str = RTSPDB_EH_creat_text(\"dsf\");")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "RTER_name = RTSPER_name(error_code);")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "RTER_text = RTSPER_text(error_code);")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "error_str = RTSPDB_EH_creat_text(\"%s - %s\\n[%s:%s]\", RTER_text, infor_str, func_name, RTER_name);")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "RTSPDB_EH_log_error(error_code, link_error, error_str, __FILE__, __LINE__);")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "free(infor_str);")				
		Insert_Line_Before_Next SetBufSelText ( hbuf, "free(error_str);")		
		Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")		
	}

	if(input == 2)
	{
	
		Insert_Line_Before_Next SetBufSelText ( hbuf, "error_code = RT4A_PARAMETER_ERROR;")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "infor_str = RTSPDB_EH_creat_text(\"dsf\");")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "RTER_name = RTSPER_name(error_code);")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "RTER_text = RTSPER_text(error_code);")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "error_str = RTSPDB_EH_creat_text(\"%s - %s\\n[%s:%s]\", RTER_text, infor_str, func_name, RTER_name);")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "RTSPDB_EH_log_error(error_code, link_error, error_str, __FILE__, __LINE__);")		
		Insert_Line_Before_Next SetBufSelText ( hbuf, "free(infor_str);")				
		Insert_Line_Before_Next SetBufSelText ( hbuf, "free(error_str);")		
	}

	stop
}

/********************************************************************
*函数原型:
			Macro Creat_error_OK()
*参数说明:
			无
*功能说明:
			在当前位置刷出如下内容
			if(error_code == OK)
			{
			
			}
*返回值:
			无
********************************************************************/
Macro Creat_error_OK()
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


	Insert_Line_Before_Next SetBufSelText ( hbuf, "if(error_code == OK)")
	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")		
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")		

	stop
}


/********************************************************************
*函数原型:
			Macro Creat_test_function()
*参数说明:
			无
*功能说明:
			刷出测试接口函数
*返回值:
			无
********************************************************************/
Macro Creat_test_function()
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

	var first_ch_index	//第一个字符
	var last_ch_index	//最后一个字符索引
	var param_count		//参数个数
	var point_flag		//指针标识
	var step_flag		//找类型或者变量的标识

	var param_struct	//变量全名
	var f_ch			//第一个字母
    var szFunc			//

	var tmp_buf			//临时缓冲
	var tmp_ln			//临时缓冲中的行号
	var tmp_ln_count	//临时缓冲最大行号
	var tmp_count
	var hnewWnd			//临时窗口

	var tmp_union
	var in_out


    hwnd = GetCurrentWnd( )     // 取得当前窗口
    if(hwnd == 0)
        stop
    hbuf = GetCurrentBuf( )     // 取得当前文件缓冲

	ln = GetWndSelLnFirst (hwnd)	//取得当前的行号

	sz_text=GetBufLine(hbuf,ln)	//取得当前行内容

	all_name = sz_text

	//取得字符串长度
	len = strlen(sz_text)

	//取得函数名称
    szFunc = GetSymbolLocationFromLn(hbuf, ln);

	//查找函数左括号	
	index=0
	ch=sz_text[index]
	while(ch!="(")
	{
		index=index+1
		ch=sz_text[index]
	}


	//建立缓冲
	tmp_buf = NewBuf ("tmp_buff")
	tmp_ln = 0


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
				//Msg(param_struct.flag)


				//将采集到的数据写入buff
				if(param_struct.type != "")
				{
					AppendBufLine(tmp_buf, param_struct.type)				
					AppendBufLine(tmp_buf, param_struct.flag)
					AppendBufLine(tmp_buf, param_struct.variable)
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


    //hnewWnd = NewWnd(tmp_buf)
	tmp_count = 0
	
	//删除本行
//	Delete_Line

	sz_text = cat("//", sz_text)

	DelBufLine ( hbuf, ln )
	InsBufLine ( hbuf, ln, sz_text )


	Cursor_Down


	//以下部分为创建
	Insert_Line SetBufSelText ( hbuf, "int test_" # szFunc.Symbol # "()")
	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "    int error_code = OK;")	

	//插入参数
	while(tmp_count < param_count)
	{
		param_struct.type = GetBufLine (tmp_buf, tmp_count*3) 
		param_struct.variable = GetBufLine (tmp_buf, tmp_count*3+2) 
		Insert_Line_Before_Next SetBufSelText ( hbuf, param_struct.type # " " # param_struct.variable # ";")	
		tmp_count = tmp_count+1
	}
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")	
	
	//插入是否打开CN
	Insert_Line_Before_Next SetBufSelText ( hbuf, "#ifdef _CN_SP_")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "CN4A_task_init(NULL);")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "#endif")	

	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")	

	//插入同步接口
	Insert_Line_Before_Next SetBufSelText ( hbuf, "#ifdef _SYNCHRONIZ_MODE_")	

	//插入测试代码
	Insert_Line_Before_Next SetBufSelText ( hbuf, "error_code = " # szFunc.Symbol # "( ")	

	//插入参数
	tmp_count = 0
	while(tmp_count < param_count)
	{

		param_struct.type = GetBufLine (tmp_buf, tmp_count*3) 
		param_struct.flag = GetBufLine (tmp_buf, tmp_count*3+1) 
		param_struct.variable = GetBufLine (tmp_buf, tmp_count*3+2) 
		if(param_struct.flag == 1)
		{
			SetBufSelText ( hbuf, "&")			
		}
		SetBufSelText ( hbuf, param_struct.variable # ",")	
		tmp_count = tmp_count+1
	}
	Backspace
	SetBufSelText ( hbuf, ");")	

	//同步接口结束
	Insert_Line_Before_Next SetBufSelText ( hbuf, "#endif")	
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")	



	//插入异步接口
	Insert_Line_Before_Next SetBufSelText ( hbuf, "#ifdef _ASYNCHRONIZ_MODE_")	

	//插入测试代码
	Insert_Line_Before_Next SetBufSelText ( hbuf, "error_code = " # szFunc.Symbol # "_req( ")	

	//插入参数
	tmp_count = 0
	while(tmp_count < param_count)
	{
		param_struct.flag = GetBufLine (tmp_buf, tmp_count*3+1)
		if(param_struct.flag == 1)
		{
			tmp_count = tmp_count+1
			continue
		}
		
		param_struct.type = GetBufLine (tmp_buf, tmp_count*3) 
		param_struct.variable = GetBufLine (tmp_buf, tmp_count*3+2) 

		SetBufSelText ( hbuf, param_struct.variable # ",")	
		tmp_count = tmp_count+1
	}
	Backspace
	SetBufSelText ( hbuf, ");")	

	Insert_Line_Before_Next SetBufSelText ( hbuf, "if(error_code == 0)")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "    error_code = " # szFunc.Symbol # "_wait(TIME_OUT,")	

	//插入参数
	tmp_count = 0
	while(tmp_count < param_count)
	{
		param_struct.flag = GetBufLine (tmp_buf, tmp_count*3+1)
		if(param_struct.flag ==0 )
		{
			tmp_count = tmp_count+1
			continue
		}
		
		param_struct.type = GetBufLine (tmp_buf, tmp_count*3) 
		param_struct.variable = GetBufLine (tmp_buf, tmp_count*3+2) 

		if(param_struct.flag == 1)
		{
			SetBufSelText ( hbuf, "&")			
		}

		SetBufSelText ( hbuf, param_struct.variable # ",")	
		tmp_count = tmp_count+1
	}
	Backspace
	SetBufSelText ( hbuf, ");")	

	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")	

	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    #endif")	

	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")	
	//插入是否打开CN
	Insert_Line_Before_Next SetBufSelText ( hbuf, "#ifdef _CN_SP_")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "CN4A_task_exit();")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "#endif")	

	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")	

	//插入打印
	Insert_Line_Before_Next SetBufSelText ( hbuf, "printf(\"/***********************************************/\\n \");")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "printf(\"" # szFunc.Symbol # " is called\\n \");")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "printf(\"error_code = 0x%x\\n \", error_code);")	

	//插入参数
	tmp_count = 0
	while(tmp_count < param_count)
	{
		param_struct.type = GetBufLine (tmp_buf, tmp_count*3) 

		if(param_struct.type == "int" || param_struct.type == "SMEE_BOOL")
		{
			tmp_union = "%d"			
		}
		else
		{
			if(param_struct.type == "double" || param_struct.type == "float")
			{
				tmp_union = "%e"			
			}
			else
			{
				tmp_union = "%b"						
			}
		}
		param_struct.flag = GetBufLine (tmp_buf, tmp_count*3+1) 
		if(param_struct.flag == 0)
		{
			in_out = "[__IN_]:"
		}
		else
		{
			in_out = "[_OUT_]:"		
		}
		
		param_struct.variable = GetBufLine (tmp_buf, tmp_count*3+2) 
		Insert_Line_Before_Next SetBufSelText ( hbuf, "printf(\"" # in_out # param_struct.variable # " = " # tmp_union # "\\n \", " # param_struct.variable # ");")	
		tmp_count = tmp_count+1
	}

	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")	

	CloseBuf (tmp_buf)
	stop

}


/********************************************************************
*函数原型:
			macro Creat_IO_function()
*参数说明:
			无
*功能说明:
			刷出2级仿真的函数
*返回值:
			无
********************************************************************/
macro Creat_IO_function()
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
	var tmp_buf
	var tmp_ln
	var param_count
	var first_ch_index
	var last_ch_index
	var step_flag
	var point_flag
	var f_ch
	var param_struct
	var tmp_count
	var param_str
	var other_name

	var param_index_1	//参数名1
	var param_index_2	//参数名2
	


    hwnd = GetCurrentWnd( )     // 取得当前窗口
    if(hwnd == 0)
        stop
    hbuf = GetCurrentBuf( )     // 取得当前文件缓冲

	ln = GetWndSelLnFirst (hwnd)	//取得当前的行号

	sz_text=GetBufLine(hbuf,ln)	//取得当前行内容

	all_name = sz_text

	//取得字符串长度
	len = strlen(sz_text)

	//取得函数名称
    szFunc = GetSymbolLocationFromLn(hbuf, ln);

	//查找函数左括号	
	index=0
	ch=sz_text[index]
	while(ch!="(")
	{
		index=index+1
		ch=sz_text[index]
	}

	//建立缓冲
	tmp_buf = NewBuf ("tmp_buff")
	tmp_ln = 0


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
				//Msg(param_struct.flag)


				//将采集到的数据写入buff
				if(param_struct.type != "")
				{
					AppendBufLine(tmp_buf, param_struct.type)				
					AppendBufLine(tmp_buf, param_struct.flag)
					AppendBufLine(tmp_buf, param_struct.variable)
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

	param_index_1 = index 

	//取得函数名称
	index=0
	ch=sz_text[index]
	while(ch!=")")
	{
		index=index+1
		ch=sz_text[index]
	}
	param_index_2 = index

	param_str = strmid(sz_text, param_index_1, param_index_2)






	index=0
	ch=sz_text[index]
	while(ch!="_")
	{
		index=index+1
		ch=sz_text[index]
	}
	layer_name= strtrunc (sz_text,index)	//取得层次名
	layer_name = tolower(layer_name)

	len = strlen(sz_func_name)

	other_name = strmid(sz_func_name, index, len)
	
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

	Insert_Line_Before_Next SetBufSelText ( hbuf, "SMEE_BOOL sim_mode_flag = SMEE_FALSE;")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "if(sim_mode_flag == SMEE_TRUE)")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "    error_code = " # layer_name # "_sim" # other_name # "( ")


	//插入参数
	tmp_count = 0
	while(tmp_count < param_count)
	{
		param_struct.variable = GetBufLine (tmp_buf, tmp_count*3+2) 
		SetBufSelText ( hbuf, param_struct.variable # ",")	
		tmp_count = tmp_count+1
	}
	Backspace
	SetBufSelText ( hbuf, ");")	

	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "else")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")	

	Insert_Line_Before_Next SetBufSelText ( hbuf, "    error_code = " # layer_name # "_real" # other_name # "( ")

	//插入参数
	tmp_count = 0
	while(tmp_count < param_count)
	{
		param_struct.variable = GetBufLine (tmp_buf, tmp_count*3+2) 
		SetBufSelText ( hbuf, param_struct.variable # ",")	
		tmp_count = tmp_count+1
	}
	Backspace
	SetBufSelText ( hbuf, ");")	

	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")

	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "return error_code;")	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")

	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "int " # layer_name # "_sim" # other_name # param_str # ")")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")

	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "int " # layer_name # "_real" # other_name #  param_str # ")")

	CloseBuf (tmp_buf)

	stop
}

/********************************************************************
*函数原型:
			macro Great_Doc_Text()
*参数说明:
			无
*功能说明:
			抽取函数头注释，使之形成一份doc文档的初稿
*返回值:
			无
********************************************************************/
macro Great_Doc_Text()
{
    var hbuf            // 文件缓冲
    var hwnd            // 窗口句柄
    var hnewBuf
    var hnewWnd
    var ln              // 光标所在行的行号
    var lnMax
    var szLine          // 光标所在行的内容
    var szBegin
    var szEnd

    var szText
    var szFunc

    hwnd = GetCurrentWnd( )     // 取得当前窗口
    if(hwnd == 0)
        stop
    hbuf = GetCurrentBuf( )     // 取得当前文件缓冲
    lnMax = GetBufLineCount( hbuf )
    szBegin = "/********************************************************************"
    szEnd = "********************************************************************/"


    // 创建新的文件缓冲
    hnewBuf = NewBuf("Result")

    ln = 0
    while(ln < lnMax)
    {
        // 获取当前行内容
        szLine = GetBufLine(hbuf, ln)
        // 如果是函数头开始，逐行读取内容至新的文件缓冲，直到函数头结束
        if(szLine == szBegin)
        {
            szFunc = GetBufLine(hbuf, ln+4)
            ichStart = 16
            ichEnd = IchInString(szFunc, "(")
            szFunc = strmid(szFunc, ichStart, ichEnd)

            AppendBufLine(hnewBuf, szFunc)
            AppendBufLine(hnewBuf, szLine)
            ln = ln + 1
            szLine = GetBufLine(hbuf, ln)
            while(szLine != szEnd)
            {
                AppendBufLine(hnewBuf, szLine)
                ln = ln + 1
                szLine = GetBufLine(hbuf, ln)
            }
            AppendBufLine(hnewBuf, szEnd)
        }
        ln = ln + 1
    }

    // 将新的文件缓冲
    hnewWnd = NewWnd(hnewBuf)
}








/********************************************************************
*函数原型:
			macro Creat_if_define()
*参数说明:
			无
*功能说明:
			刷出整个文件的ifdefine，例如文件名为smee.h,则刷出以下代码
			#ifndef __SMEE_H_
			#define __SMEE_H_

			#endif
			
*返回值:
			无
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



