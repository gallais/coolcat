This is a cool page
===================

We can write **markdown** for the _surrounding_ text.

## And here is some rendered tikz:

```tikzpicture
\def \n {5}
\def \radius {3cm}
\def \margin {8} % margin in angles, depends on the radius

\foreach \s in {1,...,\n}
{
  \node[draw, circle] at ({360/\n * (\s - 1)}:\radius) {$\s$};
  \draw[->, >=latex] ({360/\n * (\s - 1)+\margin}:\radius)
    arc ({360/\n * (\s - 1)+\margin}:{360/\n * (\s)-\margin}:\radius);
}
```

taken from the [example filter](https://pandoc.org/lua-filters.html#building-images-with-tikz)

## And here is a commutative diagram:

```tikzcd
\LARGE
A_f \arrow{r}{\varphi_f} \arrow[swap]{d}{\varrho_x^f} & B_g \arrow{d}{\varrho_x^g} \\
A_x \arrow{r}{\varphi_y} & B_y
```
