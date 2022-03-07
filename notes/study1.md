---
title: "Study 1: strsplit(object,separator)[1]] |> length()"
output: html_notebook
editor_options: 
  chunk_output_type: inline
---
<style type="text/css">
body{
font-size: 18pt;
}
</style>

study1.R  
version 1.0: whether variable can be made into type factor  
author: Richard Careaga  
Date: 2022-03-01  

---

**Converting variables to factors**

Purpose: We want to convert a large number of variables now represented by `type integer` or `type character` numbers into `factors`, where `levels` are assigned to the different numbers based on strings of characters containing possible answers to survey questions, where the answers are represented by a string of characters, such as "1. Yes; 2. No."


```{r}
# find out if numeric vectors have more than one value 
bad <- c(rep(1,100))
good <- c(sample(1:2,100, replace = TRUE))
testit <- data.frame(bad = bad, good = good)
sapply(sapply(testit,unique),length)

# create a vector of type character

ans <- c("1. Yes; 2. No.")
```

The variable `ans` represents two possible answers to a survey question and we want to make the variables `bad` and `good` into factors using `ans` as the levels, which we do with `factor(testit[,c(1,2)], labels = ans)`, but if there are more possible answers than recorded values of responses, the factor conversion will fail if, as here, a variable records responses as 1, solely&mdash;like variable `bad` (while variable `good` has both 1 and 2).

*Find out how many choices the `ans` vector contains*

```{r}
strsplit(ans,"; ")[[1]] |> length()
```

This shows that there are two possible answers to the `bad` and `good` variables. Of course, we could just *count* the answers, but we have to do this more than 200 times and I, anyway, am bound to mess up, which is why we're developing this programmatic way of doing it.

The statement, `strsplit(ans,"; ")[[1]] |> length()` is equivalent to `length(strsplit(ans,"; ")[[1]])`. The pipe operator `|>` like the magrittr pipe operator `%>%` used in the tidyverse takes the value (result) of the immediately preceding function and uses it as the argument (input) to another; which style to use is  a matter of personal taste.

Let ``strsplit(ans,"; ")[[1]]` be called part 1 and `length()` part 2.

`length()` is easy, because it just counts the length of a vector or list (plus some other objects).

Part 1 is what `length()` counts.

Part 1 has to be a list or a vector we see by that using the `str()` "structure" function on `strsplit(ans,"; ")`

```{r}
str(strsplit(ans,"; "))
```

Let's shorthand `strsplit(ans,"; ")` with a temporary^[Use temporary variables like these freely to drill down to the details; once you understand the nature of an object, it's usually more convenient to write the script without temporary variables, which cuts down on the number of names to keep in mind.] variable, `a`.

```{r}
a <- strsplit(ans,"; ")
```

`a` stands for anything; it's my naming convention for temporary objects; if I need more than one b (but not c which is the name of a function)

What `typeof` (type) is `a`?

```{r}
typeof(a)
```

How long is `a`?

```{r}
length(a)
```

That means it is a list of one object. What object?

```{r}
typeof(a[[1]])
```

It is an object of `type` character.

Cut down again on the parens and brackets

```{r}
b <- a[[1]]
b
```

How long is it?

```{r}
length(b)
```

What are its parts?

```{r}
b[1]
b[2]
```
Expand back

```{r}
strsplit(ans,"; ")
strsplit(ans,"; ")[[1]]
```

Finally, `strsplit` splits the object `ans`, "1. Yes; 2. No." into separate pieces on the semicolon ; into the two pieces "1. Yes" and "2. No."

So the final translation is split the string containing the semicolon separated answers into two strings and take the resulting `list` object, subset (extract) the (single) embedded `vector` with the `[[]]` operator and then find the length.

