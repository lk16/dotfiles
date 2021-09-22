### Get total size of all S3 buckets

How to get the total size of all files in a bucket, for all buckets

* Make sure `awscli` is installed
* Make sure keys are set up properly
* Run this
```sh
for bucket in $(aws s3 ls | cut -d ' ' -f 3); do
    echo -n "$bucket "
    aws s3 ls --summarize --recursive s3://"$bucket"/ | grep 'Total Size'
done
```

* Run this on the output file
```sh
<output_file tr -s ' ' | sort -rnk 4
```
