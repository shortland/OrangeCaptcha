function fetch_img()
{
	$("#captcha_holder").load("captcha.pl");
	localStorage.removeItem('captcha_sub1');
	localStorage.removeItem('captcha_sub2');
	localStorage.removeItem('captcha_sub3');
}
function captcha_click(idn)
{
	var is_pressed = localStorage.getItem(idn);
	if(is_pressed == "true")
	{
		$("#"+idn).css({'opacity':'1.0'});
		localStorage.setItem(idn, 'false');
		var got_one_cap = localStorage.getItem('captcha_sub1');
		var got_two_cap = localStorage.getItem('captcha_sub2');
		var got_three_cap = localStorage.getItem('captcha_sub3');
		
		if(got_one_cap == idn)
		{
			localStorage.removeItem('captcha_sub1')
		}
		if(got_two_cap == idn)
		{
			localStorage.removeItem('captcha_sub2')
		}
		if(got_three_cap == idn)
		{
			localStorage.removeItem('captcha_sub3')
		}
	}
	else 
	{
		$("#"+idn).css({'opacity':'0.5'});
		localStorage.setItem(idn, 'true');

		var got_one_cap = localStorage.getItem('captcha_sub1');
		if(!got_one_cap)
		{	
			localStorage.setItem('captcha_sub1', idn);
		}
		else
		{
			var got_two_cap = localStorage.getItem('captcha_sub2');
			if(!got_two_cap)
			{
				localStorage.setItem('captcha_sub2', idn);
			}
			else 
			{
				var got_three_cap = localStorage.getItem('captcha_sub3');
				if(!got_three_cap)
				{
					localStorage.setItem('captcha_sub3', idn);
				}
				else
				{
					alert("You've already chosen 3, to clear choices, re-click a selection or refresh.");
					$("#"+idn).css({'opacity':'1.0'});
				}
			}
		}
	}
}