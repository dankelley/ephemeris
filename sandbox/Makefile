# This Makefile holds some tests of query strings.

test1: force
	curl "https://ssp.imcce.fr/webservices/miriade/api/ephemcc.php?-name=s:Moon&-type=&-ep=(2020-01-01)&-nbd=5&-step=1d&-tscale=UTC&-observer=@500&-theory=INPOP&-teph=1&-tcoor=1&-oscelem=astorb&-mime=text&-from=MiriadeDoc" > test1.txt

test2: force
	curl "https://ssp.imcce.fr/webservices/miriade/api/ephemcc.php?-name=s:Moon&-type=&-ep=(1 January 2020)&-nbd=5&-step=1d&-tscale=UTC&-observer=@500&-theory=INPOP&-teph=1&-tcoor=1&-oscelem=astorb&-mime=text&-from=MiriadeDoc" > test2.txt

test3: force
	curl "https://ssp.imcce.fr/webservices/miriade/api/ephemcc.php?-name=s:Moon&-type=&-ep=1 January 2020&-nbd=5&-step=1d&-tscale=UTC&-observer=@500&-theory=INPOP&-teph=1&-tcoor=1&-oscelem=astorb&-mime=text&-from=MiriadeDoc" > test3.txt

test4: force
	curl "https://ssp.imcce.fr/webservices/miriade/api/ephemcc.php?-name=s:Moon&-type=&-ep='2020-01-01&nbsp;12h'&-nbd=5&-step=1d&-tscale=UTC&-observer=@500&-theory=INPOP&-teph=1&-tcoor=1&-oscelem=astorb&-mime=text&-from=MiriadeDoc" > test4.txt

test5: force
	curl "https://ssp.imcce.fr/webservices/miriade/api/ephemcc.php?-name=s:Moon&-type=&-ep='2020-01-01&nbsp;12h'&-nbd=5&-step=1.5d&-tscale=UTC&-observer=@500&-theory=INPOP&-teph=1&-tcoor=1&-oscelem=astorb&-mime=text&-from=MiriadeDoc" > test5.txt

force:
