/**************************************************************************
* Copyright (C) 2007, �Ϻ�΢����װ�����޹�˾
* All rights reserved.
* ��Ʒ�� : SS B500/10
* ������� : Struct.em
* ģ������ : Struct.em
* �ļ����� : test.em
* ��Ҫ���� : ���ļ���Ҫ�����˶Խṹ���������ز����ĺꡣ
* ��ʷ��¼ : 
* �汾    ����         ����        ����
* V1.0   2007-03-26    �ŷ�Ԫ      �����ļ�
* V1.1   2007-03-26    �ŷ�Ԫ      ���Ӷ����������֧��
* V1.2   2007-06-06    �ŷ�Ԫ      ��ԭ����Test.em�������������
									���Ӷ�unsigned��֧��
**************************************************************************/

/*--------------V1.0---------------------------------------------------------*/
//V1.0
//������ɽṹ���������
//temp_buf��ʽ
//"~" + "���" + "$" + "��������" + "!" + "��������" + "&" + "Ԫ�ػ��߽ṹ" + "*"

/*--------------V1.1---------------------------------------------------------*/
//V1.1
//���Ӷ����������֧��
//dimension_tmp_buf��ʽ
//��һ��Ϊ�ܵ�ά��,�Ժ����δ����Ӧ��ά��
//array_tmp_buff��ʽ
//[0][0][0],....,
//[0][0][1]
//....
//[i-1],[j-1],[k-1]

/*--------------V1.2---------------------------------------------------------*/
//V1.2
//��STRUCT_parse_line�����Ӳ��ִ��룬��unsigned֧��
//Լ�����нṹ������ĺ궼��STRUCTΪ��ʼ����
//ԭ��parse_struct��Ϊ STRUCT_auto_parse
//ԭ��parse_line  ��Ϊ STRUCT_parse_line
//ԭ��mcaro_to_number ��Ϊ STRUCT_mcaro_to_number
//ԭ��write_array_format ��Ϊ STRUCT_write_array_format
//ԭ��parse_buff ��Ϊ STRUCT_parse_buf_line
//ԭ��write_MC_file ��ΪSTRUCT_write_MC_file
//ԭ��auto_printf ��ΪSTRUCT_auto_printf
//ԭ��test_struct ��Ϊ STRUCT_test_use



/********************************************************************
*����ԭ��:
			macro STRUCT_test_use()
*����˵��:
			��
*����˵��:
			�Խṹ��ĵ���ʹ�õ����ַ���
			1 ���ɻ��������ļ�
			2 ʹ��printf��ʽ��ӡ
*����ֵ:
			��
********************************************************************/
macro STRUCT_test_use()
{
	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	var ln				//�к�
	var htmpbuf
	var hnewWnd
	var input			//����
	var lay_num			//����


	hwnd = GetCurrentWnd ( )//ȡ�õ�ǰ����
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//ȡ�õ�ǰ�ļ�����

	htmpbuf = NewBuf ("tmp_buf")

	ln = GetWndSelLnFirst (hwnd)	//ȡ�õ�ǰ���к�

	lay_num = 0;

	Jump_To_Base_Type
	
	STRUCT_auto_parse(htmpbuf, hwnd, hbuf, ln, lay_num)

    hnewWnd = NewWnd(htmpbuf)


	input = Ask ("����:0-�Զ���ӡ,1-���ɻ��������ļ�")

	//�Զ���ӡ
	if(input == 0)
	{
		STRUCT_auto_printf (htmpbuf)
	}

	//���ɻ��������ļ�
	if(input == 1)
	{
		STRUCT_write_MC_file(htmpbuf)	
	}

//    hnewWnd = NewWnd(htmpbuf)
	CloseBuf (htmpbuf)
	stop
	
}



/********************************************************************
*����ԭ��:
			macro STRUCT_write_MC_file(htmpbuf)
*����˵��:
            htmpbuf: 
            	��STRUCT_auto_parse���ɵĻ���
*����˵��:
			�������е����ݴ�ӡΪ�������������ļ�
*����ֵ:
			��
********************************************************************/
macro STRUCT_write_MC_file(htmpbuf)
{
	var ln_count //���峤��
	var ln		//��ǰ��
	var print_buf	//��ӡ����
	var string		//��ӡ�ı����ַ���
	var data		//�����������	
	var ln_text		//ָ���е�����
	var cur_lay		//��ǰ����

	var diff		//ָ���в����뵱ǰ����֮��

	var index 		//�ַ���������

	var ch			//�ַ�
	var hnewWnd		//�µĴ���
	var unit		//��ӡ��ʽ����λ
	var input		//���������
	var lay_num		//����

	var str1
	var str2
	var MC_buf		//�µ�MC����

	var input

	input = Ask ("������������ļ�����")

	//ȡ��htmpbuf����
	ln_count = GetBufLineCount (htmpbuf)

	//��������
	MC_buf = NewBuf ("MC_buf")

	ln = 0

	AppendBufLine(MC_buf, "/***********************************************************/")
	AppendBufLine(MC_buf, "			�������������ļ���������Ҫ�ֶ��޸�!!!")
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
		//ȡ�û����е�ĳһ��
		ln_text = GetBufLine(htmpbuf,ln);
		//����ȡ������
		data = STRUCT_parse_buf_line(ln_text)

		str1 = ""
		str2 = ""
		lay_num = data.layer_num ;
		//��д����
		while(lay_num > 0)
		{
			str1 = str1 # "\t";
			lay_num = lay_num - 1
		}

		//��д��������
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
	//��MC_buf��ʾ
    hnewWnd = NewWnd(MC_buf)
}

/********************************************************************
*����ԭ��:
			macro STRUCT_auto_printf(htmpbuf)
*����˵��:
            htmpbuf: 
            	��STRUCT_auto_parse���ɵĻ���
*����˵��:
			�������е����ݴ�ӡΪprintf��ʽ������
*����ֵ:
			��
********************************************************************/
macro STRUCT_auto_printf(htmpbuf)
{
	var ln_count 	//���峤��
	var ln			//��ǰ��
	var print_buf	//��ӡ����
	var string		//��ӡ�ı����ַ���
	var data		//�����������	
	var ln_text		//ָ���е�����
	var cur_lay		//��ǰ����

	var diff		//ָ���в����뵱ǰ����֮��

	var index 		//�ַ���������

	var ch			//�ַ�
	var hnewWnd		//�µĴ���
	var unit		//��ӡ��ʽ����λ
	var input		//�������

	ln_count = GetBufLineCount (htmpbuf)

	//������ӡ����
	print_buf = NewBuf ("print_buf")

	ln = 0
	cur_lay = 1


	input = Ask ("�����������")

	while(ln < ln_count)
	{
		ln_text = GetBufLine(htmpbuf,ln);

		data = STRUCT_parse_buf_line(ln_text)

		//�����struct,������Ӧ��string
		if(data.union == "struct")
		{
			//�������Ĳ�ȵ�ǰ���ٻ�����ͬ
			if(data.layer_num <= cur_lay)
			{
				//��������˶��ٲ�
				diff = 	cur_lay - data.layer_num + 1	//���������ͬ������Ҫ�������1��
				//���û�в��� ���� �ۼ��ַ�Ϊ��
				while(diff != 0 || string == nil)
				{
					index = strlen(string)

					if(index == 0)
					{
						break
					}
					index = index -2
					ch = string[index]

					while(ch != "." && index != 0)//���ҵ�����2��".",����Ϊ��
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

				//����string���ݣ����ѵ�ǰ�ṹ������Ƽ�¼��ȥ
				string = cat (string, data.variable # ".")
			}
			else
			{//����Ǹ���һ��Ľṹ��
				string = cat (string, data.variable # ".")
			}
			//��¼��ǰ�Ĳ���
			cur_lay = data.layer_num
		}
		else	 /*�������������¼*/
		{
			//�жϲ������޸���Ӧ��string
			if(data.layer_num <= cur_lay)
			{
				//���������ͬ������Ҫ�������1��
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
					while(ch != "." && index != 0)//���ҵ�����2��".",����Ϊ��
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
			//��¼��ǰ�Ĳ���
			cur_lay = data.layer_num -1

			//������д�뻺��

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
*����ԭ��:
			STRUCT_auto_parse(htmpbuf, wnd_old, buf_old, ln_old, lay_num_old)
*����˵��:
            htmpbuf: 
            	���ڴ�Žṹ���������Ļ��壬��ÿ�еĸ�ʽ���¡�
            	"~" + "���" + "$" + "��������" + "!" + "��������" + "&" + "Ԫ�ػ��߽ṹ" + "*"	
			wnd_old:
				��ת֮ǰ�Ĵ��ھ����
			buf_old:
				��תǰ�Ļ��塣
			ln_old:
				��תǰ���кš�
            lay_num_old
            	��תǰ�Ĳ�����
*����˵��:
			������ǰ�Ľṹ�壬���������λ�õĽṹ�塣
*����ֵ:
			�ú꽫�������ȫ��д�뵽htmpbuf���У�û�з���ֵ��
********************************************************************/
macro STRUCT_auto_parse(htmpbuf, wnd_old, buf_old, ln_old, lay_num_old)
{
	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	var Selection		//ѡ�з�Χ
	var ln				//��ǰ�к�
	var ln_end			//��ǰ�ṹ��Ľ�����
	var rtn				//�����ṹ����ÿһ�еķ��ؽ��
	var struct_type		//�ṹ�����ͣ��ж���enum����struct
	var wnd_sel			//ѡ������

	var hbuf_new		//��ת���µĻ���
	var hwnd_new		//��ת���µĴ���
	var ln_new			//��ת���µ���
	var index			//����
	var lay_num			//���
	var tmp_buf			//���ڴ����ʱ���ݻ���

	var dimension_tmp_buf	//���ڴ��ά��
	var array_tmp_buff		//���ڴ���Ѿ������õ�ά��

	var ln_text			//ȡ��ĳһ�е�����
	var ln_text_len		//ȡ��ĳһ�е������ַ����ĳ���
	var find_flag		//�ж��Ƿ��ҵ�
	var index_last		//����
	var array_number	//����ά��

	var total_number	//�����ʵ�ʴ�С
	var act_arry_name	//����ʵ��ά��������
	var temp_str		//��ʱ�ַ���

	var hbuf_macro	//�����ڵĻ���
	var hwnd_macro	//�����ڵĴ���
	var ln_macro	//�����ڵ���


	//��ڣ���������
	lay_num = lay_num_old +1
	
	//ȡ�õ�ǰ����
	hwnd = GetCurrentWnd ( )
	if ( hwnd == 0 )
		stop
	//ȡ�õ�ǰ�ļ�����
	hbuf = GetCurrentBuf ( )

	//ȡ�õ�ǰ��ѡ�з�Χ
	Selection = GetWndSel (hwnd)
	ln = Selection.lnFirst +1
	ln_end = Selection.lnLast 
	
	//�ӵ�һ�п�ʼ����
	while(1)
	{
		//����ÿһ��
		rtn = STRUCT_parse_line(hbuf, ln)

		//����ǿ���
		if(rtn == nil)
		{
			ln = ln+1
			continue
		}

		//����ǽṹ���β		
		if(rtn == "struct_end")
		{
			break;
		}

		//�����鴦��array_dimension��ʾ����ά��
		if(rtn.array_dimension > 0) 
		{
			//������ʱ����
			dimension_tmp_buf = NewBuf ("dimension_tmp_buf")
			array_tmp_buff = NewBuf ("array_tmp_buff")

			//��ά��д��ά������
			AppendBufLine(dimension_tmp_buf, rtn.array_dimension)

			//ȡ�õ�ǰ������
			ln_text = GetBufLine(hbuf, ln)	
			find_flag = IchInString(ln_text, ";")
			ln_text = strmid(ln_text, 0, find_flag)
			//��ǰ��ȡ���ַ���
			ln_text_len = strlen(ln_text)

			//���������ά��			
			index = 0
			while(index < ln_text_len)
			{
				if(ln_text[index] == "[")
				{
					index = index + 1
					//�������ַ�
					while(ln_text[index] == " " || ln_text[index] == "\t") 
					{
						index = index + 1
					}
					//��ʱindexΪ����ά�����׸��ַ�����

					//����ά���ý���
					index_last = index
					while(ln_text[index_last] != " " && ln_text[index_last] != "\t" && ln_text[index_last] != "]")
					{

						index_last = index_last + 1
					}
					//��ʱindex_lastΪ����ά�����׸��ַ�����
			
					//�õ�ά��
					array_number = strmid(ln_text, index, index_last)

					//�жϲ��������ֻ��Ǻ�
					if(IsNumber(array_number) == TRUE)/*�������������*/
					{
						AppendBufLine(dimension_tmp_buf, "@array_number@")
					}
					else	/*��������Ǻ�*/
					{
						//�趨��ת��
						SetBufIns (hbuf, ln, index)

						//��ת
						Jump_To_Base_Type

						//ȡ�õ�ǰ��wnd_sel
						hwnd_macro = GetCurrentWnd ( )//ȡ�ú����ڵĴ���
						if ( hwnd_macro == 0 )
							stop
						hbuf_macro= GetCurrentBuf ( )//ȡ�ú����ڵ��ļ�����
						ln_macro = GetWndSelLnFirst (hwnd_macro)	//ȡ�ú����ڵ��к�

						//����Դ����,���궨��ת��������.
						array_number = STRUCT_mcaro_to_number(hwnd_macro, hbuf_macro, ln_macro)
						//��ά��д��ά������
						AppendBufLine(dimension_tmp_buf, "@array_number@")
	
						//����ԭ���Ĵ���
						SetCurrentWnd (hwnd)
						//����ԭ���Ļ���
						SetCurrentBuf (hbuf)
						//�趨����
						SetBufIns (hbuf, ln, index)
					}
				
				}

				index = index + 1
			}

			//����ת������Ҫ�ø�ʽ,д��array_tmp_buff,���ʽ����
			//[0][0][0],....,
			//[0][0][1]
			//....
			//[i-1],[j-1],[k-1]
			
			total_number = STRUCT_write_array_format(dimension_tmp_buf, array_tmp_buff)

			//��������
			temp_str = rtn.variable

			//������������д�뵽htmpbuf����
			index = 0
			while(index < total_number)
			{
				//ȡ�������׺�ַ�������ʽΪ[i-1],[j-1],[k-1]
				act_arry_name = GetBufLine(array_tmp_buff, index)

				//������ӵ��������
				rtn.variable = temp_str # act_arry_name

				//�ж�����������ǻ������ͻ��Ƿǻ�������
				if(rtn.type == "int" || rtn.type == "double" ||rtn.type == "float" || rtn.type == "SMEE_BOOL" || rtn.type == "short" || rtn.type == "char")
				{
					//���䰴��ʽд�뵽���嵱��
					AppendBufLine(htmpbuf,"~" # lay_num # "$" # rtn.variable # "!" # rtn.type # "&" # "element" # "*")
				}
				else	//������ǻ�������
				{
					//�趨��ת��λ��
					SetBufIns (hbuf, ln, rtn.firstCh+1)
					//��ת
					Jump_To_Base_Type	

					//ȡ���µĴ���
					hwnd_new= GetCurrentWnd ( )
					if ( hwnd_new== 0 )
						stop
					//ȡ���µ��ļ�����
					hbuf_new= GetCurrentBuf ( )

					//ȡ���µĵ��к�
					ln_new = GetWndSelLnFirst (hwnd_new)	
					//ȡ��ѡ������
					wnd_sel = GetWndSel (hwnd_new)
					tmp_buf =GetBufLine (hbuf_new, ln_new)
					struct_type = strmid (tmp_buf, wnd_sel.ichFirst, wnd_sel.ichLim)
					//ȡ������
					if(struct_type == "enum")	/*�����ö�٣����ջ������ʹ���*/
					{
						//��ת��ȥ
						Go_Back
						//д��htmpbuf
						AppendBufLine(htmpbuf, "~" # "@lay_num@" # "$" # rtn.variable # "!" # rtn.type # "&" # "element" # "*")
					}

					//����ǽṹ�壬ѭ������
					if(struct_type == "struct")			
					{
						//д��htmpbuf
						AppendBufLine(htmpbuf, "~" # "@lay_num@" # "$" # rtn.variable # "!" # rtn.type # "&" # "struct" # "*")
						//��������
						STRUCT_auto_parse(htmpbuf, hwnd, hbuf, ln, lay_num)
					}
				}	
				index = index + 1
			}

			//�ر�������ʱ����
			CloseBuf (dimension_tmp_buf)
			CloseBuf (array_tmp_buff)
		}
		else//��������
		{
			//�ж��Ƿ��ǻ�������
			if(rtn.type == "int" || rtn.type == "double" ||rtn.type == "float" || rtn.type == "SMEE_BOOL" || rtn.type == "short" || rtn.type == "char")
			{
				//���䰴��ʽд�뵽���嵱��
				AppendBufLine(htmpbuf,"~" # lay_num # "$" # rtn.variable # "!" # rtn.type # "&" # "element" # "*")
			}
			else	//������ǻ�������
			{
				//�趨��ת��λ��
				SetBufIns (hbuf, ln, rtn.firstCh+1)

				//��ת
				Jump_To_Base_Type	

				//ȡ���µĴ���
				hwnd_new= GetCurrentWnd ( )
				if ( hwnd_new== 0 )
					stop

				//ȡ���µ��ļ�����
				hbuf_new= GetCurrentBuf ( )

				//ȡ���µ��к�
				ln_new = GetWndSelLnFirst (hwnd_new)	

				//ȡ��ѡ������
				wnd_sel = GetWndSel (hwnd_new)

				//ȡ�ø����ַ���
				tmp_buf =GetBufLine (hbuf_new, ln_new)

				//ȡ������
				struct_type = strmid (tmp_buf, wnd_sel.ichFirst, wnd_sel.ichLim)

				//�����ö��
				if(struct_type == "enum")
				{
					//��ת��ȥ
					Go_Back

					//д��htmpbuf
					AppendBufLine(htmpbuf, "~" # "@lay_num@" # "$" # rtn.variable # "!" # rtn.type # "&" # "element" # "*")
				}

				//����ǽṹ�壬ѭ������
				if(struct_type == "struct")			
				{
					//д��htmpbuf
					AppendBufLine(htmpbuf, "~" # "@lay_num@" # "$" # rtn.variable # "!" # rtn.type # "&" # "struct" # "*")
					//��������
					STRUCT_auto_parse(htmpbuf, hwnd, hbuf, ln, lay_num)
				}
			}		
		}
		//�к�++
		ln = ln+1
	}

 	//����
	lay_num = lay_num +1

	//����ԭ���Ĵ���
	SetCurrentWnd (wnd_old)
	//����ԭ���Ļ���
	SetCurrentBuf (buf_old)
	//����ԭ�����У���һ��	
	SetBufIns (buf_old, ln_old, 0)
}


/********************************************************************
*����ԭ��:
			macro STRUCT_parse_line(cur_buf, ln)
*����˵��:
            cur_buf: 
            	ָ���Ļ���
            ln:
            	�ƶ�����
*����˵��:
			���������е�ָ���У������ؽ����
*����ֵ:
			switch(ָ���е��ַ���)
			{
				case ����:
				case ���ַ���:
				case "{":
				case ��ע�͵�����:
				case û���ҵ�";"
					return nil
				case "}"
					return "struct_end"
				default:	//�������
					data.variable //��������
					data.type //��������
					data.firstCh	//�������Ƶĵ�һ���ַ�
					data.array_dimension //����ά��
					return data.
			}
********************************************************************/
macro STRUCT_parse_line(cur_buf, ln)//�жϴ�����������У������� { }��
{
	var sz_text //��ǰ������
	var index	//����
	var len		//�ַ�������
	var find_flag	//�ҵ��ı�־
	var file_name //�ļ�����

	var data	//���صĽ������

	var first_ch	//��һ���ǿ��ַ�
	var last_ch		//���һ���ַ�

	var step_flag	//0 �����ͣ�1 �ұ���

	var array_dimension	//�����ά��,���鵽"["�Ĵ���;

	//������ά��ָ��Ϊ0��Ĭ�ϲ�������
	array_dimension = 0
	
	//ȡ��ָ��������
	sz_text = GetBufLine(cur_buf,ln)	

	//ȡ���ַ�������
	len = strlen(sz_text)

	//�жϱ����Ƿ�Ϊ��
	if(len == 0)
	{
		//���ؿս��
		data = nil;
		return data
	}

	//�жϱ����Ƿ�ȫ��Ϊ�ո����tab
	index = 0
	while(sz_text[index] == " " || sz_text[index] == "\t")
	{
		index = index + 1
		if(index == len)
		{
			//���ؿս��
			data = nil;
			return data
		}
	}

	//�������ע�͵��ˣ���һ���ַ�Ϊ'/'
	if(sz_text[index] == "/")
	{
			//���ؿս��
			data = nil;
			return data
	}
	
	//��ʱindexΪ��һ����Ϊ�յ��ַ�

	//����ҵ�"}",�ṹ�����
	find_flag = IchInString(sz_text, "{")
	if(find_flag >= 0)
	{
		//���ؿս��
		data = nil;
		return data
	}

	//����ҵ�"{"
	find_flag = IchInString(sz_text, "}")
	if(find_flag >= 0)
	{
		//���ؽ����ַ�
		data = "struct_end";
		return data
	}
	
	//����ҵ��ֺ�,˵��������Ч
	find_flag = IchInString(sz_text, ";")

	//���û���ҵ������а��տ��д���
	if(find_flag < 0)
	{
		file_name = GetBufName (cur_buf)	
		data = nil
		return data
	}

	//�������������ַ���
	first_ch = index
	step_flag = 0
	while(index < len && sz_text[index] != " " && sz_text[index] != "\t")
	{
		index = index +1
	}
	last_ch = index

	//ȡ��������
	data.type = strmid(sz_text , first_ch, last_ch)	

	//�����"unsigned",�����ٴβ���������
	if(data.type == "unsigned")
	{
		//�������ַ�
		while(sz_text[index] == " " || sz_text[index] == "\t")
		{
			index = index + 1
		}

		//������������
		first_ch = index
		step_flag = 0
		while(index < len && sz_text[index] != " " && sz_text[index] != "\t")
		{
			index = index +1
		}
		last_ch = index
	
		//ȡ��������
		data.type = strmid(sz_text , first_ch, last_ch)		
	}

	//�������ַ�
	while(sz_text[index] == " " || sz_text[index] == "\t")
	{
		index = index + 1
	}

	//���ұ�����
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

	//��������ά��,���Ϊ0,��������
	array_dimension = Find_times_occured(strmid(sz_text , 0, find_flag),"[")

	data.array_dimension = array_dimension

	return data
}



/********************************************************************
*����ԭ��:
			macro STRUCT_parse_line(cur_buf, ln)
*����˵��:
            cur_buf: 
            	ָ���Ļ���
            ln:
            	ָ������
*����˵��:
			���ṹ���еú�ת����Ϊ����
*����ֵ:
			�Ѿ�ת���������
********************************************************************/
macro STRUCT_mcaro_to_number(hwnd_macro, hbuf_macro, ln_macro)
{

	var macro_sel	//��ѡ�е�����
	var sz_text		//�ַ���
	var find_flag	//�ַ����������
	var Result		//�����������ֵ
	var index		//����
	var len			//�ַ�������
	var index_first	
	var index_last
	var find_flag2
	var ln_step		//��������ƶ��Ĵ���
	var up_step		//ö�ٸı�Ĵ���

	Result = ""
	up_step = 0
	ln_step = 0
	
	//ѡ�к����ڵ���
	sz_text = GetBufLine (hbuf_macro, ln_macro)

	//�ж�sz_text���Ƿ���� define �ַ���
	find_flag = FindString(sz_text , "#define")

	if(find_flag == "X")	//˵����ö��
	{

		while(1)//ѭ������
		{
			//ȡ�ø�������
			sz_text = GetBufLine (hbuf_macro, ln_macro - ln_step)
			len = strlen(sz_text)

			ln_step = ln_step + 1	/*�����ƶ�һ��*/


			//�жϱ����Ƿ�ȫ��Ϊ�ո����tab
			index = 0
			while(sz_text[index] == " " || sz_text[index] == "\t")
			{
				index = index + 1
				if(index == len)	//����ǿ���,��������ѭ��
				{
					break;
				}
			}

			if(index == len)	//����ǿ���,�������һ��
			{
				continue
			}

			//�������ע�͵���
			if(sz_text[index] == "/")
			{
				continue
			}
			
			//����ж���"{"
			if(sz_text[index] == "{")	//����ҵ���ö�ٵ���ʼ��
			{
				Result = up_step -1
				break;
			}

			//��ע�Ͳ��ֹ���
			find_flag2 = IchInString(sz_text, "/")
			if(find_flag2 > 0)	//���˵����ע��
			{
				sz_text = strmid(sz_text, 0, find_flag2)
				len = strlen(sz_text)
			}	

			//�����Ƿ����"=",�������"=",�����һ����ȡ
			find_flag2 = IchInString(sz_text, "=")
			if(find_flag2 > 0)
			{
				index = find_flag2 +1
				//���˿ո�
				while(sz_text[index] == " " || sz_text[index] == "\t")
				{
					index = index + 1
					if(index == len)
					{
						Msg("����ú궨��,��=" # ln_macro)
						stop
					}
				}

				index_first = index

				//ȡ�÷ǿ��ַ�
				while(index <len && sz_text[index] != " " && sz_text[index] != "\t" && sz_text[index] != ",") 
				{
					index = index +1
				}	

				Result = strmid(sz_text, index_first, index)

				//������ý����������
				if(IsNumber(Result) != TRUE)
				{
						Msg("����ú궨��,��=" # ln_macro)
						stop
				}

				Result = Result + up_step 
					
				break
			}

			//ö������1
			up_step = up_step + 1
		}

	}
	else	//˵���Ǻ궨��
	{
		//ȡ���ַ�������
		len = strlen(sz_text)

		//ȡ�ú����ڵ�����
		macro_sel = GetWndSel (hwnd_macro)

		//�ҳ����һ���ַ�������
		index = macro_sel.ichLim + 1

		//ȥ���ո�,tab
		while(sz_text[index] == " " || sz_text[index] == "\t")
		{
			index = index +1			
			if(index == len)
			{
				Msg("����ú궨��,��=" # ln_macro)
				stop
			}
		}

		//�ҵ���һ���ǿ��ַ�
		index_first = index

		//ȡ�÷ǿ��ַ�
		while(index <len && sz_text[index] != " " && sz_text[index] != "\t" && sz_text[index] != "/") 
		{
			index = index +1
		}			

		Result = strmid(sz_text, index_first, index)

		//������ý����������
		if(IsNumber(Result) != TRUE)
		{
				Msg("����ú궨��,��=" # ln_macro)
				stop
		}

	}

	return Result
}

/********************************************************************
*����ԭ��:
			macro STRUCT_parse_line(cur_buf, ln)
*����˵��:
            src_buf: 
            	Դ���壬
            dest_buf:
            	Ŀ�껺��
*����˵��:
			��src�е����ݰ��ո�ʽд��destbuf����ʽ����
			//[0][0][0],....,
			//[0][0][1]
			//....
			//[i-1],[j-1],[k-1]
*����ֵ:
			����ά��֮��
********************************************************************/
macro STRUCT_write_array_format(src_buf, dest_buf)
{
	var ln_count	//Դbuf������
	var cur_ln		//��ǰ��

	var total_number	//���е�ά��֮��
	var temp_number	
	var index			//����
	var temp_str		//��ʱ�ַ���

	var remainder	//����
	var result		//����ý��

	var hnewWnd
	var div_result	//�������


	total_number = 1


	//ȡ��Դbuf������	
	ln_count = GetBufLineCount (src_buf)

	//�Ӻ���ǰ��������������е�ά��֮��
	cur_ln = ln_count - 1
	while(cur_ln > 0)
	{
		temp_number = GetBufLine(src_buf , cur_ln)
		total_number = total_number * temp_number
		cur_ln = cur_ln -1
	}

	//����Щ���ݰ���ʽд
	index = 0
	while(index < total_number)
	{
		result = index
		temp_str = ""
		//����Դ�����е��������
		cur_ln = ln_count - 1
		while(cur_ln > 0)
		{
			//ȡ��ԭ�����е�����
			temp_number = GetBufLine(src_buf , cur_ln)
			//ȡ�ó���
			div_result = result / temp_number
			//ȡ������
			remainder = result - (div_result * temp_number)//������
			//����������
			temp_str = "[" # remainder # "]" # temp_str
			//���½������
			result = div_result 
			//ԭ��������
			cur_ln = cur_ln - 1
		}
		//�������¼��Ŀ�껺��
		AppendBufLine(dest_buf, temp_str)
		//��������
		index = index +1
	}

	return total_number
}

/********************************************************************
*����ԭ��:
			macro STRUCT_parse_buf_line(ln_text)
*����˵��:
            ln_text: 
            	�ṹ����������ʱ�����е�һ�����ݣ����ʽ����:
			"~" + "���" + "$" + "��������" + "!" + "��������" + "&" + "Ԫ�ػ��߽ṹ" + "*"
*����˵��:
			����ʱ�����е�һ�����ݽ���
*����ֵ:
			����ǿ��з���nil��
			���򷵻�data����ʽ����
			data.layer_num ���		
			data.variable ��������
			data.type ��������
			data.union �����Ƿ�ʽ�ṹ��ı�־
********************************************************************/
macro STRUCT_parse_buf_line(ln_text)
{
	var data		//���ݽ��
	var index		//����
	var index_first	//���ַ�����
	var index_last	//ĩ�ַ�����
	var ch			//�ַ�

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

	//���Ҳ���
	index_first = index+1
	while(ch != "$")
	{
		ch = ln_text[index]
		index = index +1
	}
	index_last = index	
	data.layer_num = strmid(ln_text,index_first, index_last-1)

	//���ұ�������
	index_first = index
	while(ch != "!")
	{
		ch = ln_text[index]
		index = index +1
	}
	index_last = index	
	data.variable = strmid(ln_text,index_first, index_last-1)

	//���ұ�������
	index_first = index
	while(ch != "&")
	{
		ch = ln_text[index]
		index = index +1
	}
	index_last = index	
	data.type = strmid(ln_text,index_first, index_last-1)

	//������struct

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



