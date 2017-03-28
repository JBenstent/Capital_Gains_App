
//check if value is numeric
function IsNumeric(strString) {
	var strValidChars = "0123456789.";
	var strChar;
	var blnResult = true;

	if (strString.length == 0) return false;

	//check if strString consists of valid characters listed above
	for (i = 0; i < strString.length && blnResult == true; i++) {
		strChar = strString.charAt(i);
		if (strValidChars.indexOf(strChar) == -1) {
			blnResult = false;
		}
	}
	return blnResult;
}



/*-------------------------Profit Calculator Start------------------------------*/

function profit_calc(acc_curr, acc_curr_name, curr_pairs, otp, ctp, buy, trade_size) {

	otp = getNumberFromLocal(otp);
	ctp = getNumberFromLocal(ctp);
	if(!isNaN(otp)!=false && !isNaN(ctp) != false) {
		//$("#msgbox").hide(); //hide old HTML
		$("#msgboxtotal").hide();
		$("#calculating").fadeIn(100); //show Loading message


		$.get('/ajax_func.php', {
			'action' : 'profit_calc',
			'acc_curr' : acc_curr,
			'curr_pairs' : curr_pairs,
			'otp': otp,
			'ctp': ctp,
			'buy': buy,
			'trade_size' : trade_size
		}, function(data) {
			if (data.length > 0) {
				data = getLocalNumber(data);
				$("#msgboxtotal").fadeTo(200,0.1,function() {
					if(data=='error') {
						$(this).html('Error Occured!').removeClass().addClass('messageboxerror_with_border').fadeTo(900,1);
					} else {
						 var curr_signs = new Array();
						 curr_signs[17] = "&#128;";
						 curr_signs[4] = "";
						 curr_signs[2] = "&#165;";
						 curr_signs[15] = "&#36;";
						 curr_signs[3] = "&#163;";
						 curr_signs[1] = "";
						 curr_signs[5] = "";
						 curr_signs[9] = "&#8378;";
						 curr_signs[12] =  "&#36;";

						$("#calculating").hide(); //hide the Loading div
						$(this).html(curr_signs[acc_curr]+data).fadeIn(100).fadeTo(300,1); //Show prepared HTML with answer
						$("#msgbox").html(acc_curr_name).fadeIn(100).fadeTo(300,1);
					}
				});


			} else {
				//$("#calcerror").fadeIn("slow");
			}

		});
	}
}

function Get_last_of_pair(PairID) {
	if((!isNaN(PairID))!=false) {

		$.get('/ajax_func.php', {
			'action' : 'Get_Pair_last',
			'pairs' : PairID
		}, function(data) {

						$("#CTP").val(getLocalNumber(data)); //Show prepared HTML with answer

		});
	}
}
/*-------------------------Profit Calculator END------------------------------*/

/*-------------------------CarryTrade Calculator START------------------------------*/
function carrytrade_calc() {

	if(val_inputs("#LRate,#BRate,#trade_size,#Days")) {
		var acc_val = $("select[name='acc_curr'] :selected").val();

		$("#loader").fadeIn('fast');

		$.get('/ajax_func.php', {
			'action' : 'CarryTrade_Interest',
			'acc_curr' : acc_val,
			'curr_pair' : $("#curr_pair :selected").val(),
			'buy': $("#buy:checked").val(),
			'lrate': $("#LRate").val(),
			'brate': $("#BRate").val(),
			'trade_size': $("#trade_size").val(),
			'days' : $("#Days").val()
		}, function(data) {
			if (data.length > 0) {

						 var curr_signs = new Array();
						 curr_signs[17] = "&#128;";
						 curr_signs[4] = "";
						 curr_signs[2] = "&#165;";
						 curr_signs[15] = "&#36;";
						 curr_signs[3] = "&#163;";
						 curr_signs[1] = "";
						 curr_signs[5] = "";
						 curr_signs[12] =  "&#36;";

						 var total = data.split(",");

						 var html = "<td class='subtotalbig arial_18_b'>"+curr_signs[acc_val]+toFixed(total[0],2)+"</td><td class='standart arial_18_b'>"+curr_signs[acc_val]+toFixed(total[1],2)+"</td><td class='arial_18_b'>"+curr_signs[acc_val]+toFixed(total[2],2)+"</td>";

						$(".subtotal").html(html).fadeIn(100).fadeTo(300,1);
						$("#msgbox").html($("select[name='acc_curr'] :selected").text());
						$("#loader").fadeOut('fast');
			}

		});
	}
}

function carrytrade_pairchange() {

		$.get('/ajax_func.php', {
			'action' : 'CarryTrade_Interestbypair',
			'curr_pair' : $("#curr_pair :selected").val()
		}, function(data) {
			if (data.length > 0) {
						var interests = data.split(",");
						if($("#buy:checked").val() == 1)
						{
							$("#LRate").val(interests[0]); //Show prepared HTML with answer
							$("#BRate").val(interests[1]);
						}
						else
						{
							$("#LRate").val(interests[1]); //Show prepared HTML with answer
							$("#BRate").val(interests[0]);
						}
			}

		});
	}
/*-------------------------CarryTrade Calculator END------------------------------*/


/*-------------------------Pip Calculator STRAT-----------------------------------*/

function pip_calc_submit(lang)
{
	if(val_inputs("#trade_size")) {

	  if (!validateNumeric('#trade_size', true, true)) {
	       return;
	  }

		var acc_val = $("select[name='acc_curr'] :selected").val();

		$("#loader").fadeIn('fast');

		$.get('/ajax_func.php', {
			'force_lang' : lang,
			'action' : 'pip_calc_value',
			'acc_curr' : acc_val,
			'trade_size': getNumberFromLocal($("#trade_size").val())
		}, function(data) {
			if (data.length > 0) {
				var $html = $(data);
				$html.find('*')
					.filter(function(el) { return !$(el).children().length })
					.each(function(i, el) { return el.innerHTML = el.innerHTML.replace(/\./g, window.wmtData.decimalPoint);});

				$("#total").html($html);
				$("#loader").fadeOut('fast');
			}
		});
	}
}
/*-------------------------Pip Calculator END-----------------------------------*/
