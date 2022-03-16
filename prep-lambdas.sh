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

mkdir lambdas
cp index.js lambdas/index.js
#cp package.json lambdas/package.json
#cp package-lock.json lambdas/package-lock.json
zip lambdas.zip lambdas
rm -r lambdas
cd /

echo "******************************************************************"
