bundle:
	git archive --format=tar.gz HEAD -o rider-id-source.tar.gz
	tar -zcvf rider-id-measurements.tar.gz data/measurements
clean:
	rm rider-id-source.tar.gz rider-id-measurements.tar.gz
