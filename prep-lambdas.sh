#
#mkdir lambdas
#cp src/index.js index.js
#cd .
#echo "Zipping lambda"
#zip -r lambda.zip .
#rm lambdas
#echo "Zip complete"
#
#cd /
#npm ci > /dev/null || npm install > /dev/null


echo "******************************************************************"

cd src
zip -r lambdas.zip .
cd -

echo "******************************************************************"
