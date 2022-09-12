
# generate the config files from 1 to 240: e.g. ["1", "2", ..., "240"]
configFiles = [str(i) for i in range(1,47)]

# give a file name for your output 
csvFile = open("./raceOnonurb.csv", "w")
csvFile.writelines("Config,Outcome,Predictor,Coef,std\n")

for config in configFiles:
	print("parsing:{} ".format(config))
	output_line = [config]
	for line in file("./raceOnonurb/{}".format(config) + ".txt"): 
		line = line.translate(None, "\r\n")
		if line.startswith("death="):
			lineInfo = line.split("\t")
			output_line.append(lineInfo[0].split("death_", 1)[1])
		line = line.translate(None, "\r\n")
		if line.startswith(("pm","no2")):
			lineInfo = line.split("\t")
			output_line.append(lineInfo[0])
			output_line.append(lineInfo[1])
			output_line.append(lineInfo[2])
	csvFile.writelines(",".join(output_line) + "\n")
csvFile.close()
