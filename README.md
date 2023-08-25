# point_spec_dev

Code to get the spectra graph from three devices: ASD Fieldspec 3, [ASD Fieldspec 4](https://www.malvernpanalytical.com/en/products/product-range/asd-range/fieldspec-range), and [SVC HR-1024i Spectroradiometer](https://spectravista.com/instruments/hr-1024i/).

SVC has different file format than the ASD3 and ASD4. Run svc_format2ASD.R to convert it to a similar file format as ASD.

The output graph (.png) file will have the same name as the input file (like all.txt or all_reflect.csv will have output as all.png or all_reflectance.png). 

Sensor ranges in nm:
 - **ASD 3**: 350-1000 (VNIR), 1000-1830 (SWIR1), 1830-2500 (SWIR2)
 - **ASD 4**: 350-1000 (VNIR), 1001-1800 (SWIR1), 1801-2500 (SWIR2)
 - **SVC**: 350-1000 (VNIR), 1000-1898 (SWIR1), 1898-2500 (SWIR2)
