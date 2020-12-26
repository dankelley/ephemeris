# Try to find ephemeris data.
# See https://ssp.imcce.fr/webservices/miriade/api/ephemcc/ and
# related websites for details.  I have very little idea how to construct
# these query strings.  In particular, I do not know the field to set
# a date for the query.  I sort of thought it was the '-ep' field,
# but clearly it is not, since 'make test1' produces a file
# that starts at the present date.  Presumably, there are parameters to set
# the start date, the end date, and the number of steps in between.


test1: force
	curl "https://ssp.imcce.fr/webservices/miriade/api/ephemcc.php?-name=s:Moon&-type=&-ep=(2020-01-01)&-nbd=5&-step=1d&-tscale=UTC&-observer=@500&-theory=INPOP&-teph=1&-tcoor=1&-oscelem=astorb&-mime=text&-from=MiriadeDoc" > test1.txt

test2: force
	curl "https://ssp.imcce.fr/webservices/miriade/api/ephemcc.php?-name=s:Moon&-type=&-ep=(1 January 2020)&-nbd=5&-step=1d&-tscale=UTC&-observer=@500&-theory=INPOP&-teph=1&-tcoor=1&-oscelem=astorb&-mime=text&-from=MiriadeDoc" > test2.txt
test3: force
	curl "https://ssp.imcce.fr/webservices/miriade/api/ephemcc.php?-name=s:Moon&-type=&-ep=1 January 2020&-nbd=5&-step=1d&-tscale=UTC&-observer=@500&-theory=INPOP&-teph=1&-tcoor=1&-oscelem=astorb&-mime=text&-from=MiriadeDoc" > test3.txt
test4: force
	curl "https://ssp.imcce.fr/webservices/miriade/api/ephemcc.php?-name=s:Moon&-type=&-ep='2020-01-01&nbsp;12h'&-nbd=5&-step=1d&-tscale=UTC&-observer=@500&-theory=INPOP&-teph=1&-tcoor=1&-oscelem=astorb&-mime=text&-from=MiriadeDoc" > test4.txt

eph.out: eph.R
	Rscript eph.R

force:
