
context("Worldwide_Population")


test_that("This application only supports these countries: {'Sweden','Italy','Greece','Turkey'}",{
   expect_error(Worldwide_Pollution$new(list("Spain","Turkey")))
   expect_error(Worldwide_Pollution$new(list("Brazil","Sweden")))
   expect_error(Worldwide_Pollution$new(list()))
})

test_that("Number of observations",{
  worldwide<-Worldwide_Pollution$new(list("Turkey","Greece","Italy","Sweden"))
  expect_equal(worldwide$responses$Turkey$nhits==0,FALSE)
  expect_equal(worldwide$responses$Italy$nhits==0,FALSE)
})


test_that("Type of data",{
  worldwide<-Worldwide_Pollution$new(list("Turkey","Greece","Italy","Sweden"))
  expect_true(is.data.frame(worldwide$get_only_faced_data(worldwide$responses$Italy,c("value_pm5","Category PM25"))))
})

test_that("Parameter should be a  character list",{
  worldwide<-Worldwide_Pollution$new(list("Turkey","Greece","Italy","Sweden"))
  expect_error(worldwide<-class(a$get_facets_all_responses(c("Turkey"))))
  expect_error(worldwide<-class(a$get_facets_all_responses(c(5))))
})

test_that("select correct data",{
  worldwide<-Worldwide_Pollution$new(list("Turkey","Greece","Italy","Sweden"))
   worldwide<-Worldwide_Pollution$new(list("Sweden"))
   expect_error(worldwide$get_facets_all_responses(facet_vector = list("value_pm5","Category PM25")))
   })


