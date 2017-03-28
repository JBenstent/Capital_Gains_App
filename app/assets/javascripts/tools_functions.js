/*     ----------- Calculation & Validation Functions for Calculators START-------------     */
function toFixed(num,decim)
{
	num *= Math.pow(10,decim);
	num = Math.round(num);
	num /= Math.pow(10,decim);
	return num;
}


function val_inputs(inputs)
{
	var inputsArray = inputs.split(",");
	var ret=true;
	var i=0;
	while(i < inputsArray.length)
	{
		HideError(inputsArray[i]);
		if(isNaN(getNumberFromLocal($(inputsArray[i]).val())) || $(inputsArray[i]).val().length == 0)
		{
			ShowError(inputsArray[i]);
			ret = false;
		}
		i++;
	}
	return ret;
}

function getNumberFromLocal(str) {
	return str.replace(wmtData.decimalPoint, '.');
}

function getLocalNumber(num) {
	num = num.toString().split('.');
	num[0] = num[0].replace(/,/g, wmtData.thousandSep);
	return num.join(wmtData.decimalPoint);
}

function validateNumeric(b, boolAvoidZero, boolAvoidNegative) {
    var a = b.split(",");
    var c = true;
    var d = 0;
    var v = '';
	var numeric;

	boolAvoidZero     = boolAvoidZero !== undefined ? boolAvoidZero : false;
	boolAvoidNegative = boolAvoidNegative !== undefined ? boolAvoidNegative : false;

    while (d < a.length) {
        HideError(a[d]);

        v = $(a[d]).val();
	    numeric = getNumberFromLocal(v);
		if (boolAvoidZero) {
			if (isNaN(numeric) || v.length == 0 || +numeric == 0) {
				ShowError(a[d]);
				return false;
			}
		}

		if (boolAvoidNegative) {
			if (isNaN(numeric) || v.length == 0 || +numeric < 0) {
				ShowError(a[d]);
				return false;
			}
		}

		if (isNaN(numeric) || v.length == 0) {
            ShowError(a[d]);
            c = false
        }

        d++;
    }

    return c;
}


function ShowError(box)
{
	$(box).removeClass("input_border").addClass("input_error");
}

function HideError(box)
{
	$(box).removeClass("input_error").addClass("input_border");
}

/*     ----------- Calculation & Validation Functions for Calculators END-------------     */




/*     ----------- Pivot calculator Javascript Start -------------     */
function pivot_submit()
{
	$("#loader").fadeIn('fast').fadeOut();
	var high = parseFloat($("#HRate").val());
	var low = parseFloat($("#LRate").val());
	var close = parseFloat($("#CRate").val());
	var open = parseFloat($("#ORate").val());

	if(val_inputs("#HRate,#LRate,#CRate,#ORate") && high >= low && high >= close && high >= open && low <= close && low <=open)
	{


		var bpivot = (high + low + close) / 3;
		var bsup1,res1;
		bsup1 = 2 * bpivot - high;
		bres1 = 2 * bpivot - low;

		$("#br3").text(toFixed(high + 2*(bpivot - low),4));
		$("#br2").text(toFixed(bpivot+(bres1-bsup1),4));
		$("#br1").text(toFixed(bres1,4));
		$("#bp").text(toFixed(bpivot,4));
		$("#bs1").text(toFixed(bsup1,4));
		$("#bs2").text(toFixed(bpivot - (bres1 - bsup1),4));
		$("#bs3").text(toFixed(low - 2*(high - bpivot),4));

		var wpivot = (high + low + (2 * close))/4;

		$("#wr1").text(toFixed((2*wpivot)-low,4));
		$("#wr2").text(toFixed(wpivot + high - low,4));
		$("#wp").text(toFixed(wpivot,4));
		$("#ws1").text(toFixed((2 * wpivot) - high,4));
		$("#ws2").text(toFixed((wpivot - high) + low,4));

		$("#cr1").text(toFixed(close + ((high - low) * (1.1/12)),4));
		$("#cr2").text(toFixed(close + ((high - low) * (1.1/6)),4));
		$("#cr3").text(toFixed(close + ((high - low) * (1.1/4)),4));
		$("#cr4").text(toFixed(close + ((high - low) * (1.1/2)),4));

		$("#cs1").text(toFixed(close - ((high - low) * (1.1/12)),4));
		$("#cs2").text(toFixed(close - ((high - low) * (1.1/6)),4));
		$("#cs3").text(toFixed(close - ((high - low) * (1.1/4)),4));
		$("#cs4").text(toFixed(close - ((high - low) * (1.1/2)),4));


		var tmpv;


			if (close < open)
				tmpv = (high + (low * 2) + close);
            if (close > open)
            	tmpv = ((high * 2) + low + close);
            if (close == open)
            	tmpv = (high + low + (close * 2));

            $("#demar1").text(toFixed((tmpv / 2) - low,4));
            $("#demas1").text(toFixed((tmpv / 2) - high,4));

	}
	else
	{
		if(high < low)
		{
			ShowError("#HRate");
			ShowError("#LRate");
		}
		if(high < close)
		{
			ShowError("#HRate");
			ShowError("#CRate");
		}
		if(high < open)
		{
			ShowError("#HRate");
			ShowError("#ORate");
		}
		if(low > close)
		{
			ShowError("#LRate");
			ShowError("#CRate");
		}
		if(low > open)
		{
			ShowError("#LRate");
			ShowError("#ORate");
		}
	}
}
/*     ----------- Pivot calculator Javascript END -------------     */
