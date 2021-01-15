# MorphSkill
Matlab routines for investigating skill of morphological models

This code is in .../crs/src/MorphSkill on my TIC laptop

Key reference: Sutherland, J., Peet, A.H., and Soulsby, R.L., 2004, Evaluating the performance of morphological models: Coastal Engineering, v. 51, p. 917–939.

* `skill_estimates.m` - function that computes a range of skill estimates on two matching arrays of *observed* and *modeled* results  
* `test_skill_estimates.m` - test program for above  
* `test_spatitial_skill_estimates.m` - test using function in a sliding 2D window over array domain  

* `hitmiss.m` - does categorical comparisons and makes figure with array of map view of comparisons  
* `hitmiss_hist.m` - same thing, but puts histograms of results in array  

* `Matanzas_prestorm_topobathy.mat` - data with arrays of pre-observed, post-observed, and post-modeled data

