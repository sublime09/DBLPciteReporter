# DBLP Citation Reporter

Creates a report of impactful Computer Science conferences in the DBLP, based on citations.  

Based on the [DBLPParser](https://github.com/IsaacChanghau/DBLPParser) by Isaac Changhau, a python parser for the dataset of the [DBLP](https://dblp.org/) computer science bibliography.  The XML format of DBLP data can be downloaded as a .dtd file from [here](http://dblp.org/xml/).  

Software needed: make to run scripts easily, wget to download dataset from DBLP, gzip to uncompress dataset, [Python 3](https://www.python.org/) to parse xml.  Windows users can install make, wget, gzip all from [here](http://gnuwin32.sourceforge.net/packages.html).  

Useful make targets and commands:
- TODO: `make report` will output a small report of the most cited conferences
- `make dataset` will download and decompress the most recent dataset from DBLP automatically (may take some time)
- `make clean` will remove the dataset so that a fresh and updated dataset can be downloaded
- `make venv` will create the python virtual environment and setup the pip package requirements
- `make clean-venv` will remove the python virtual environment so it can be recreated from scratch

## The DBLP Dataset Parser

The parser requires `dtd` file, so make sure you have both `dblp-XXX.xml` (dataset) and `dblp-XXX.dtd` files. Note that you also should guarantee that both `xml` and `dtd` files are in the same directory, and the name of `dtd` file shoud same as the name given in the `<!DOCTYPE>` tag of the `xml` file. Such information can be easily accessed through `head dblp-XXX.xml` command. As shown below
```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE dblp SYSTEM "dblp-2017-08-29.dtd">
<dblp>
<phdthesis mdate="2016-05-04" key="phd/dk/Heine2010">
<author>Carmen Heine</author>
<title>Modell zur Produktion von Online-Hilfen.</title>
...
```

A sample to use the parser:
```python
def main():
    dblp_path = 'dataset/dblp.xml'
    save_path = 'article.json'
    try:
        context_iter(dblp_path)
        log_msg("LOG: Successfully loaded \"{}\".".format(dblp_path))
    except IOError:
        log_msg("ERROR: Failed to load file \"{}\". Please check your XML and DTD files.".format(dblp_path))
        exit()
    parse_article(dblp_path, save_path, save_to_csv=False)  # default save as json format
```
