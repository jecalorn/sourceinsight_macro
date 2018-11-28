/**************************************************************************
* Copyright (C) 2007, �Ϻ�΢����װ�����޹�˾
* All rights reserved.
* ��Ʒ�� : SS B500/10
* ������� : General.em
* ģ������ : General.em
* �ļ����� : General.em
* ��Ҫ���� : ���ļ���Ҫ������ͨ�ò�����ز����ĺꡣ
* ��ʷ��¼ : 
* �汾    ����         ����        ����
* V1.0   2007-06-07    �ŷ�Ԫ      �����ļ�
**************************************************************************/

/*--------------V1.0---------------------------------------------------------*/
//V1.0
//������ǰ�ĸ��ֺ��������������,��һ������liuj��д
//
//1	-	ע��ѡ�п�
//2	-	ȡ�����ע��
//3	-	����ע�ͷָ���
//4	-	�������������
//5	-	���������������
//6	-	���ݺ�������ˢ������ͷע�ͺͲ��ִ���
//7	-	ˢ���ļ�ͷע��
//8	-	���ݺ�������ˢ�����Ժ���
//9	-	���ݺ�������ˢ��2�����溯��(IO)
//10-	ɾ���ļ��еĿ���
//11-	��ȡ����ͷע�ͣ�ʹ֮�γ��ĵ�




/********************************************************************
*����ԭ��:
			macro GetCurDataTime ( )
*����˵��:
			��
*����˵��:
			ȡ��ϵͳ����
*����ֵ:
			ϵͳʱ��
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
*����ԭ��:
			macro IchInString(s, ch)
*����˵��:
			s:
				��Ҫ���ҵ��ַ�����
			ch:
				���ҵ�Ŀ���ַ���
*����˵��:
			�ж��ַ���s���Ƿ����ַ�ch.
*����ֵ:
			������ַ���s���ҵ���ch���򷵻�ʵ��λ�ã����û���ҵ�����-1
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
*����ԭ��:
			macro FindString ( source, target )
*����˵��:
			source:
				Դ�ַ�����
			target:
				Ŀ���ַ�����
*����˵��:
			�ж��ַ���source���Ƿ�������ַ���target.
*����ֵ:
			������ַ���source���ҵ���target���򷵻�ʵ��λ�ã�
			���û���ҵ�����"X"
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
*����ԭ��:
			Macro Find_times_occured(str, ch)
*����˵��:
			str:
				Դ�ַ�����
			ch:
				Ŀ���ַ�
*����˵��:
			�����ַ���ch���ַ���str�г��ֵĴ�����
*����ֵ:
			���ֵĴ�����
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
*����ԭ��:
			macro CommentBlock ( )
*����˵��:
			��
*����˵��:
			��ѡ�е�����ע�͵�
*����ֵ:
			��
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
*����ԭ��:
			macro UncommentBlock ( )
*����˵��:
			��
*����˵��:
			��ѡ�е�ע��ȡ��
*����ֵ:
			��
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
*����ԭ��:
			Macro Delete_blank_line()
*����˵��:
			��
*����˵��:
			ɾ�����ļ��еĿ��У�ע�⣬��Ҫ���ִ��
*����ֵ:
			��
********************************************************************/
Macro Delete_blank_line()
{
	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	
	hwnd = GetCurrentWnd ( )//ȡ�õ�ǰ����
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//ȡ�õ�ǰ�ļ�����

	Blank_Line_Down

	Delete_Line
	
	Top_of_File

	stop
}

/********************************************************************
*����ԭ��:
			macro Add_Line_comment()
*����˵��:
			��
*����˵��:
			��ǰλ�ò���һ��ע�ͷָ���
*����ֵ:
			��
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

    hwnd = GetCurrentWnd( )     // ȡ�õ�ǰ����
    if(hwnd == 0)
        stop
    hbuf = GetCurrentBuf( )     // ȡ�õ�ǰ�ļ�����

	ln = GetWndSelLnFirst (hwnd)	//ȡ�õ�ǰ���к�

	input = ask("0-ͷ�ļ�����; 1-�ⲿ��������; 2-�ڲ���������; 3-ȫ�����ݶ���; 4-�ⲿ��������; 5-��������; 6-���ݽṹ����; 7-����")

	if(input == 0)
	{
		input = "ͷ�ļ�����"
	}
	else if(input == 1)
	{
		input = "�ⲿ��������"
	}
	else if(input == 2)
	{
		input = "�ڲ���������"	
	}
	else if(input == 3)
	{
		input = "ȫ�����ݶ���"	
	}
	else if(input == 4)
	{
		input = "�ⲿ��������"	
	}
	else if(input == 5)
	{
		input = "��������"	
	}
	else if(input == 6)
	{
		input = "���ݽṹ����"	
	}
	else if(input == 7)
	{
		input = ask("����")
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
*����ԭ��:
			macro Creat_function()
*����˵��:
			��
*����˵��:
			�����ͣ���ں�����������ˢ������ͺ���ͷע��
*����ֵ:
			��
********************************************************************/
macro Creat_function()
{
	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	var ln				//�к�
	var sz_func_name	//���������ַ���
	var cch				//�ַ�
	var ch
	var sz_text			//�ַ���
	var index			//����
	var module_name		//ģ������
	var layer_name		//�������
	var len				//�ַ�������
	var lnFirst
	var all_name		//������ȫ��

	
	hwnd = GetCurrentWnd ( )//ȡ�õ�ǰ����
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//ȡ�õ�ǰ�ļ�����


	ln = GetWndSelLnFirst (hwnd)	//ȡ�õ�ǰ���к�

	cch='('						

	sz_text=GetBufLine(hbuf,ln)	//ȡ�õ�ǰ������
	all_name = sz_text
	len = strlen(sz_text)
	sz_text = strmid(sz_text, 4 ,len)//ȥ�� int RT

	//ȡ�ú�������
	index=0
	ch=sz_text[index]
	while(ch!="(")
	{
		index=index+1
		ch=sz_text[index]
	}
	sz_func_name=strtrunc (sz_text,index)	//ȡ�ú�����
	module_name=strtrunc(sz_text,2)	//ȡ��ģ����

	module_name = toupper(module_name)


	index=0
	ch=sz_text[index]
	while(ch!="_")
	{
		index=index+1
		ch=sz_text[index]
	}
	layer_name= strtrunc (sz_text,index)	//ȡ�ò����
	layer_name = toupper(layer_name)
	
	Insert_Line SetBufSelText ( hbuf, "/********************************************************************")
	Insert_Line_Before_Next SetBufSelText ( hbuf, "*ͷ�ļ�:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <RT4A_types.h> <RT4T_types.h> <RTMC.h> <" # layer_name # ".h>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*����ԭ��:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            "# all_name)
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*�������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*�������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*�������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*����ֵ:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            - OK")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*��������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*���ݽṹ:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*ǰ������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*��������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*α����:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "********************************************************************/")	

	Cursor_Down			//�������һ��


	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "    int error_code = OK;")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "int link_error[2] = {0, 0};")	

	Insert_Line_Before_Next SetBufSelText ( hbuf, "char *func_name = \"" # sz_func_name # "\";")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "char *error_str = NULL;")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "char *infor_str = NULL;")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "char *RTER_name = NULL;")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "char *RTER_text = NULL;")


	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "/*��ڲ�������*/")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "if("# layer_name # "_TRACING_IS_ON == SMEE_TRUE)")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")
	
	Insert_Line_Before_Next Indent_Right SetBufSelText ( hbuf, "RTSPDB_TR_trace(func_name, RTSPDB_TRACE_IN, \">()\");")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")


	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "/*���ڲ�������*/")
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
*����ԭ��:
			macro Creat_file_head()
*����˵��:
			��
*����˵��:
			���ļ��Ķ���ˢ���ļ�ͷ˵��
*����ֵ:
			��
********************************************************************/
macro Creat_file_head()
{
	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	var ln				//�к�
	var sz_func_name	//���������ַ���
	var cch				//�ַ�
	var ch
	var sz_text			//�ַ���
	var index			//����
	var module_name		//ģ������
	var file_name		//�ļ�����
	var len				//�ַ�������
	var cc_name			//�������
	var lnFirst
	var all_name		//������ȫ��
	var time			// ��ǰʱ��

	
	hwnd = GetCurrentWnd ( )//ȡ�õ�ǰ����
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//ȡ�õ�ǰ�ļ�����

	file_name = GetBufName (hbuf) //ȡ���ļ�����


	//ȡ���������
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
	
	
	cc_name=strtrunc(file_name,2)	//ȡ��ģ����

	module_name=strtrunc (file_name,index)	//ȡ��ģ��
	time = GetCurDataTime()


	ln = 0
	InsBufLine ( hbuf, ln, "/**************************************************************************" )
	InsBufLine ( hbuf, ln + 1, "* Copyright (C) 2007, �Ϻ�΢����װ�����޹�˾" )
	InsBufLine ( hbuf, ln + 2, "* All rights reserved." )
	InsBufLine ( hbuf, ln + 3, "* ��Ʒ�� : SS B500/10" )
	InsBufLine ( hbuf, ln + 4, "* ������� : " # cc_name )
	InsBufLine ( hbuf, ln + 5, "* ģ������ : " # module_name)
	InsBufLine ( hbuf, ln + 6, "* �ļ����� : " # file_name )
	InsBufLine ( hbuf, ln + 7, "* ��Ҫ���� : ")
	InsBufLine ( hbuf, ln + 8, "* ��ʷ��¼ : " )
	InsBufLine ( hbuf, ln + 9, "* �汾    ����         ����        ����" )
	InsBufLine ( hbuf, ln + 10, "* V1.0   " # time  # "    �ŷ�Ԫ      �����ļ�")	
	InsBufLine ( hbuf, ln + 11, "**************************************************************************/" )

	stop

}


/********************************************************************
*����ԭ��:
			Macro Creat_error_log()
*����˵��:
			��
*����˵��:
			�ڵ�ǰλ��ˢ�����������
*����ֵ:
			��
********************************************************************/
Macro Creat_error_log()
{

	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	var ln				//�к�
	var sz_func_name	//���������ַ���
	var cch				//�ַ�
	var ch
	var sz_text			//�ַ���
	var index			//����
	var module_name		//ģ������
	var layer_name		//�������
	var len				//�ַ�������
	var lnFirst
	var all_name		//������ȫ��
	var input

	
	hwnd = GetCurrentWnd ( )//ȡ�õ�ǰ����
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//ȡ�õ�ǰ�ļ�����

	input = Ask("0-���������Ĵ���1-�������Ĵ���; 2-��������");

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
*����ԭ��:
			Macro Creat_error_OK()
*����˵��:
			��
*����˵��:
			�ڵ�ǰλ��ˢ����������
			if(error_code == OK)
			{
			
			}
*����ֵ:
			��
********************************************************************/
Macro Creat_error_OK()
{
	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	var ln				//�к�
	var sz_func_name	//���������ַ���
	var cch				//�ַ�
	var ch
	var sz_text			//�ַ���
	var index			//����
	var module_name		//ģ������
	var layer_name		//�������
	var len				//�ַ�������
	var lnFirst
	var all_name		//������ȫ��
	
	hwnd = GetCurrentWnd ( )//ȡ�õ�ǰ����
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//ȡ�õ�ǰ�ļ�����


	Insert_Line_Before_Next SetBufSelText ( hbuf, "if(error_code == OK)")
	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")		
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")		

	stop
}


/********************************************************************
*����ԭ��:
			Macro Creat_test_function()
*����˵��:
			��
*����˵��:
			ˢ�����Խӿں���
*����ֵ:
			��
********************************************************************/
Macro Creat_test_function()
{
	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	var ln				//�к�
	var sz_func_name	//���������ַ���
	var cch				//�ַ�
	var ch
	var sz_text			//�ַ���
	var index			//����
	var module_name		//ģ������
	var layer_name		//�������
	var len				//�ַ�������
	var lnFirst
	var all_name		//������ȫ��

	var first_ch_index	//��һ���ַ�
	var last_ch_index	//���һ���ַ�����
	var param_count		//��������
	var point_flag		//ָ���ʶ
	var step_flag		//�����ͻ��߱����ı�ʶ

	var param_struct	//����ȫ��
	var f_ch			//��һ����ĸ
    var szFunc			//

	var tmp_buf			//��ʱ����
	var tmp_ln			//��ʱ�����е��к�
	var tmp_ln_count	//��ʱ��������к�
	var tmp_count
	var hnewWnd			//��ʱ����

	var tmp_union
	var in_out


    hwnd = GetCurrentWnd( )     // ȡ�õ�ǰ����
    if(hwnd == 0)
        stop
    hbuf = GetCurrentBuf( )     // ȡ�õ�ǰ�ļ�����

	ln = GetWndSelLnFirst (hwnd)	//ȡ�õ�ǰ���к�

	sz_text=GetBufLine(hbuf,ln)	//ȡ�õ�ǰ������

	all_name = sz_text

	//ȡ���ַ�������
	len = strlen(sz_text)

	//ȡ�ú�������
    szFunc = GetSymbolLocationFromLn(hbuf, ln);

	//���Һ���������	
	index=0
	ch=sz_text[index]
	while(ch!="(")
	{
		index=index+1
		ch=sz_text[index]
	}


	//��������
	tmp_buf = NewBuf ("tmp_buff")
	tmp_ln = 0


	//����Ϊ��������
	index = index + 1
	param_count = 0
	while( index <= len )
	{

		first_ch_index = index;
		last_ch_index = index;

		step_flag = 0;/*��ʼ������*/
		point_flag = 0;/*Ĭ�ϲ�Ϊָ��*/

		while(1)
		{
			//ʹfirst_ch_index��Ϊ�ո����*
			f_ch = sz_text[first_ch_index]
			while( f_ch == " " || f_ch == "*")
			{
				if(f_ch == "*")
				{
					point_flag = 1;
				}
				first_ch_index = first_ch_index + 1

				//���µ�ǰ��index
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
			
				if(step_flag == 0)/*�ҵ�����*/
				{	
					step_flag = 1
					
					last_ch_index = index ;

					param_struct.type = strmid(sz_text, first_ch_index, last_ch_index)
					//Msg(param_struct.type)
					first_ch_index = index ;
				}
				else/*�ҵ�������*/
				{
					step_flag = 0
					last_ch_index = index ;
					param_struct.variable = strmid(sz_text, first_ch_index, last_ch_index)
					//Msg(param_struct.variable)
					first_ch_index = index ;
				}
				
				//ʹfirst_ch_index��Ϊ�ո����*
				f_ch = sz_text[first_ch_index]
				while( f_ch == " " || f_ch == "*")
				{
					if(f_ch == "*")
					{
						point_flag = 1;
					}
					first_ch_index = first_ch_index + 1

					//���µ�ǰ��index
					index = first_ch_index
					f_ch = sz_text[first_ch_index]
				}
			}

			ch = sz_text[index]
			if(ch == "," || ch == ")")
			{
				param_struct.flag = point_flag
				//Msg(param_struct.flag)


				//���ɼ���������д��buff
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
	
	//ɾ������
//	Delete_Line

	sz_text = cat("//", sz_text)

	DelBufLine ( hbuf, ln )
	InsBufLine ( hbuf, ln, sz_text )


	Cursor_Down


	//���²���Ϊ����
	Insert_Line SetBufSelText ( hbuf, "int test_" # szFunc.Symbol # "()")
	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "    int error_code = OK;")	

	//�������
	while(tmp_count < param_count)
	{
		param_struct.type = GetBufLine (tmp_buf, tmp_count*3) 
		param_struct.variable = GetBufLine (tmp_buf, tmp_count*3+2) 
		Insert_Line_Before_Next SetBufSelText ( hbuf, param_struct.type # " " # param_struct.variable # ";")	
		tmp_count = tmp_count+1
	}
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")	
	
	//�����Ƿ��CN
	Insert_Line_Before_Next SetBufSelText ( hbuf, "#ifdef _CN_SP_")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "CN4A_task_init(NULL);")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "#endif")	

	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")	

	//����ͬ���ӿ�
	Insert_Line_Before_Next SetBufSelText ( hbuf, "#ifdef _SYNCHRONIZ_MODE_")	

	//������Դ���
	Insert_Line_Before_Next SetBufSelText ( hbuf, "error_code = " # szFunc.Symbol # "( ")	

	//�������
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

	//ͬ���ӿڽ���
	Insert_Line_Before_Next SetBufSelText ( hbuf, "#endif")	
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")	



	//�����첽�ӿ�
	Insert_Line_Before_Next SetBufSelText ( hbuf, "#ifdef _ASYNCHRONIZ_MODE_")	

	//������Դ���
	Insert_Line_Before_Next SetBufSelText ( hbuf, "error_code = " # szFunc.Symbol # "_req( ")	

	//�������
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

	//�������
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
	//�����Ƿ��CN
	Insert_Line_Before_Next SetBufSelText ( hbuf, "#ifdef _CN_SP_")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "CN4A_task_exit();")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "#endif")	

	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")	

	//�����ӡ
	Insert_Line_Before_Next SetBufSelText ( hbuf, "printf(\"/***********************************************/\\n \");")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "printf(\"" # szFunc.Symbol # " is called\\n \");")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "printf(\"error_code = 0x%x\\n \", error_code);")	

	//�������
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
*����ԭ��:
			macro Creat_IO_function()
*����˵��:
			��
*����˵��:
			ˢ��2������ĺ���
*����ֵ:
			��
********************************************************************/
macro Creat_IO_function()
{
	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	var ln				//�к�
	var sz_func_name	//���������ַ���
	var cch				//�ַ�
	var ch
	var sz_text			//�ַ���
	var index			//����
	var module_name		//ģ������
	var layer_name		//�������
	var len				//�ַ�������
	var lnFirst
	var all_name		//������ȫ��
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

	var param_index_1	//������1
	var param_index_2	//������2
	


    hwnd = GetCurrentWnd( )     // ȡ�õ�ǰ����
    if(hwnd == 0)
        stop
    hbuf = GetCurrentBuf( )     // ȡ�õ�ǰ�ļ�����

	ln = GetWndSelLnFirst (hwnd)	//ȡ�õ�ǰ���к�

	sz_text=GetBufLine(hbuf,ln)	//ȡ�õ�ǰ������

	all_name = sz_text

	//ȡ���ַ�������
	len = strlen(sz_text)

	//ȡ�ú�������
    szFunc = GetSymbolLocationFromLn(hbuf, ln);

	//���Һ���������	
	index=0
	ch=sz_text[index]
	while(ch!="(")
	{
		index=index+1
		ch=sz_text[index]
	}

	//��������
	tmp_buf = NewBuf ("tmp_buff")
	tmp_ln = 0


	//����Ϊ��������
	index = index + 1
	param_count = 0
	while( index <= len )
	{

		first_ch_index = index;
		last_ch_index = index;

		step_flag = 0;/*��ʼ������*/
		point_flag = 0;/*Ĭ�ϲ�Ϊָ��*/

		while(1)
		{
			//ʹfirst_ch_index��Ϊ�ո����*
			f_ch = sz_text[first_ch_index]
			while( f_ch == " " || f_ch == "*")
			{
				if(f_ch == "*")
				{
					point_flag = 1;
				}
				first_ch_index = first_ch_index + 1

				//���µ�ǰ��index
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
			
				if(step_flag == 0)/*�ҵ�����*/
				{	
					step_flag = 1
					
					last_ch_index = index ;

					param_struct.type = strmid(sz_text, first_ch_index, last_ch_index)
					//Msg(param_struct.type)
					first_ch_index = index ;
				}
				else/*�ҵ�������*/
				{
					step_flag = 0
					last_ch_index = index ;
					param_struct.variable = strmid(sz_text, first_ch_index, last_ch_index)
					//Msg(param_struct.variable)
					first_ch_index = index ;
				}
				
				//ʹfirst_ch_index��Ϊ�ո����*
				f_ch = sz_text[first_ch_index]
				while( f_ch == " " || f_ch == "*")
				{
					if(f_ch == "*")
					{
						point_flag = 1;
					}
					first_ch_index = first_ch_index + 1

					//���µ�ǰ��index
					index = first_ch_index
					f_ch = sz_text[first_ch_index]
				}
			}

			ch = sz_text[index]
			if(ch == "," || ch == ")")
			{
				param_struct.flag = point_flag
				//Msg(param_struct.flag)


				//���ɼ���������д��buff
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

	ln = GetWndSelLnFirst (hwnd)	//ȡ�õ�ǰ���к�

	cch='('						

	sz_text=GetBufLine(hbuf,ln)	//ȡ�õ�ǰ������
	all_name = sz_text
	len = strlen(sz_text)
	sz_text = strmid(sz_text, 4 ,len)//ȥ�� int RT

	//ȡ�ú�������
	index=0
	ch=sz_text[index]
	while(ch!="(")
	{
		index=index+1
		ch=sz_text[index]
	}
	sz_func_name=strtrunc (sz_text,index)	//ȡ�ú�����
	module_name=strtrunc(sz_text,2)	//ȡ��ģ����
	module_name = toupper(module_name)

	param_index_1 = index 

	//ȡ�ú�������
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
	layer_name= strtrunc (sz_text,index)	//ȡ�ò����
	layer_name = tolower(layer_name)

	len = strlen(sz_func_name)

	other_name = strmid(sz_func_name, index, len)
	
	Insert_Line SetBufSelText ( hbuf, "/********************************************************************")
	Insert_Line_Before_Next SetBufSelText ( hbuf, "*ͷ�ļ�:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <RT4A_types.h> <RT4T_types.h> <RTMC.h> <" # layer_name # ".h>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*����ԭ��:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            "# all_name)
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*�������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*�������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*�������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*����ֵ:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            - OK")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*��������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*���ݽṹ:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*ǰ������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*��������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*α����:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "********************************************************************/")	

	Cursor_Down			//�������һ��

	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "    int error_code = OK;")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "SMEE_BOOL sim_mode_flag = SMEE_FALSE;")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "if(sim_mode_flag == SMEE_TRUE)")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "    error_code = " # layer_name # "_sim" # other_name # "( ")


	//�������
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

	//�������
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
*����ԭ��:
			macro Great_Doc_Text()
*����˵��:
			��
*����˵��:
			��ȡ����ͷע�ͣ�ʹ֮�γ�һ��doc�ĵ��ĳ���
*����ֵ:
			��
********************************************************************/
macro Great_Doc_Text()
{
    var hbuf            // �ļ�����
    var hwnd            // ���ھ��
    var hnewBuf
    var hnewWnd
    var ln              // ��������е��к�
    var lnMax
    var szLine          // ��������е�����
    var szBegin
    var szEnd

    var szText
    var szFunc

    hwnd = GetCurrentWnd( )     // ȡ�õ�ǰ����
    if(hwnd == 0)
        stop
    hbuf = GetCurrentBuf( )     // ȡ�õ�ǰ�ļ�����
    lnMax = GetBufLineCount( hbuf )
    szBegin = "/********************************************************************"
    szEnd = "********************************************************************/"


    // �����µ��ļ�����
    hnewBuf = NewBuf("Result")

    ln = 0
    while(ln < lnMax)
    {
        // ��ȡ��ǰ������
        szLine = GetBufLine(hbuf, ln)
        // ����Ǻ���ͷ��ʼ�����ж�ȡ�������µ��ļ����壬ֱ������ͷ����
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

    // ���µ��ļ�����
    hnewWnd = NewWnd(hnewBuf)
}








/********************************************************************
*����ԭ��:
			macro Creat_if_define()
*����˵��:
			��
*����˵��:
			ˢ�������ļ���ifdefine�������ļ���Ϊsmee.h,��ˢ�����´���
			#ifndef __SMEE_H_
			#define __SMEE_H_

			#endif
			
*����ֵ:
			��
********************************************************************/
macro Creat_if_define()
{
	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	var file_name		//�ļ�����
	var len
	var index


	hwnd = GetCurrentWnd ( )//ȡ�õ�ǰ����
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//ȡ�õ�ǰ�ļ�����

	file_name = GetBufName (hbuf) //ȡ���ļ�����

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



