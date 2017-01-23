# HeadCount

Federal and state governments publish a huge amount of data. You can find
a large collection of it on [Data.gov](http://data.gov) -- everything from land surveys
to pollution to census data.

As programmers, we can use those data sets to ask and answer questions. We'll build upon a dataset centered around schools in Colorado provided by the Annie E. Casey foundation. What can we learn about education across the state?

Starting with the CSV data we will:

* build a "Data Access Layer" which allows us to query/search the underlying data
* build a "Relationships Layer" which creates connections between related data
* build an "Analysis Layer" which uses the data and relationships to draw conclusions

## Key Concepts

### Districts

During this project, we'll be working with a large body of data
that covers various information about Colorado school districts.

The data is divided into multiple CSV files, with the concept of
a __District__ being the unifying piece of information across the
various data files.

__Districts__ are identified by simple names (strings), and are listed
under the `Location` column in each file.

So, for example, the file `Kindergartners in full-day program.csv` contains
data about Kindergarten enrollment rates over time. Let's look at the file headers
along with a sample row:

```
Location,TimeFrame,DataFormat,Data
AGUILAR REORGANIZED 6,2007,Percent,1
```

The `Location`, column indicates the District (`AGUILAR REORGANIZED 6`), which
will re-appear as a District in other data files as well. The other columns
indicate various information about the statistic being reported. Note that
percentages appear as decimal values out of `1`, with `1` meaning 100% enrollment.

### Aggregate Data Categories

With the idea of a __District__ sitting at the top of our overall data hierarchy
(it's the thing around which all the other information is organized), we can now
look at the secondary layers.

We will ultimately be performing analysis across numerous data files within the
project, but it turns out that there are generally multiple files dealing with
a related concepts. The overarching data themes we'll be working with include:

* __Enrollment__ - Information about enrollment rates across various
grade levels in each district
* __Statewide Testing__ - Information about test results in each district
broken down by grade level, race, and ethnicity
* __Economic Profile__ - Information about socioeconomic profiles of
students and within districts

### Data Files by Category

The list of files that are relevant to each data "category" are listed below. You'll find the data files in the `data` folder of the cloned repository.

#### Enrollment

* `Dropout rates by race and ethnicity.csv`
* `High school graduation rates.csv`
* `Kindergartners in full-day program.csv`
* `Online pupil enrollment.csv`
* `Pupil enrollment by race_ethnicity.csv`
* `Pupil enrollment.csv`
* `Special education.csv`

#### Statewide Testing

* `3rd grade students scoring proficient or above on the` CSAP_TCAP.csv
* `8th grade students scoring proficient or above on the` CSAP_TCAP.csv
* `Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv`
* `Average proficiency on the CSAP_TCAP by race_ethnicity_` Reading.csv
* `Average proficiency on the CSAP_TCAP by race_ethnicity_` Writing.csv
* `Remediation in higher education.csv`

#### Economic Profile

* `Median household income.csv`
* `School-aged children in poverty.csv`
* `Students qualifying for free or reduced price lunch.csv`
* `Title I students.csv`

Ultimately, a crude visualization of the structure might look like this:

```
- District: Gives access to all the data relating to a single, named school district
|-- Enrollment: Gives access to enrollment data within that district, including:
|  | -- Dropout rate information
|  | -- Kindergarten enrollment rates
|  | -- Online enrollment rates
|  | -- Overall enrollment rates
|  | -- Enrollment rates by race and ethnicity
|  | -- High school graduation rates by race and ethnicity
|  | -- Special education enrollment rates
|-- Statewide Testing: Gives access to testing data within the district, including:
|  | -- 3rd grade standardized test results
|  | -- 8th grade standardized test results
|  | -- Subject-specific test results by race and ethnicity
|  | -- Higher education remediation rates
|-- Economic Profile: Gives access to economic information within the district, including:
|  | -- Median household income
|  | -- Rates of school-aged children living below the poverty line
|  | -- Rates of students qualifying for free or reduced price programs
|  | -- Rates of students qualifying for Title I assistance
```
