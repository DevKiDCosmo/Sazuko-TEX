\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sazuko}[A document class called Sazuko]

% Base class: article with two-column layout
\LoadClass[twocolumn]{article}

% Load required packages
\RequirePackage{xcolor}           % Color
\RequirePackage{fontspec}         % Font
\RequirePackage[bottom]{footmisc} % Footnotes
\RequirePackage{lastpage}         % Last page
\RequirePackage{luacode}
\RequirePackage{titlesec}
\RequirePackage{svg}   

% Math typesetting
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amstext}
\RequirePackage{amsfonts}
\RequirePackage{bm}
\RequirePackage{tcolorbox}

\RequirePackage[english]{babel}


% Macro
\newcommand*{\SZKyear}[1]{\def\SZK@year{#1}}\SZKyear{}
\newcommand*{\SZKlocation}[1]{\def\SZK@location{#1}}\SZKlocation{}
\newcommand*{\SZKdates}[1]{\def\SZK@dates{#1}}\SZKdates{}

\newcommand{\SZKcopyright}[2]{\def\SZK@copyright{Copyright \copyright\,#1 by #2. All rights reserved.}}
\newcommand*{\SZKarchive}[1]{\def\SZK@archive{#1}}\SZKarchive{}
\newcommand*{\SZKundertitle}[1]{\def\SZK@undertitle{#1}}\SZKundertitle{}

% Footers & Headers
\RequirePackage{fancyhdr} % Load the fancyhdr package

% Maketitle
\begin{luacode*}
function random_style(input)
    local styled_text = ""
    local i = 1

    while i <= #input do
        local char = input:sub(i, i)

        -- Check for the special case of '--'
        if char == "-" and input:sub(i+1, i+1) == "-" then
            -- If it's '--', leave it as normal
            styled_text = styled_text .. "--"
            i = i + 1 -- Skip the next character as it is part of '--'
        elseif i == 1 then
            -- Handle the first character based on case
            if char:match("%u") then
                -- Uppercase first character is normal
                styled_text = styled_text .. char
            elseif char:match("%l") then
                -- Lowercase first character is italic
                styled_text = styled_text .. "\\textit{" .. char .. "}"
            else
                -- Other first characters (e.g., symbols) are normal
                styled_text = styled_text .. char
            end
        else
            -- Apply random styling for other characters
            local rand = math.random(100)
            if rand <= 50 then
                -- 50% Normal
                styled_text = styled_text .. char
            elseif rand <= 75 then
                -- 25% Italic
                styled_text = styled_text .. "\\textit{" .. char .. "}"
            elseif rand <= 90 then
                -- 15% Bold
                styled_text = styled_text .. "\\textbf{" .. char .. "}"
            else
                -- 10% Both Bold and Italic
                styled_text = styled_text .. "\\textbf{\\textit{" .. char .. "}}"
            end
        end

        i = i + 1
    end

    return styled_text
end
\end{luacode*}

% Define a wrapper command for Lua function
\newcommand{\randomformat}[1]{\directlua{tex.print(random_style("#1"))}}

% Define a custom title page style
\fancypagestyle{titlepage}{
    \fancyhf{} % Clear all header and footer fields
    \fancyhead[C]{{\footnotesize\color{gray}\SZK@copyright}} % Custom header
    \renewcommand{\headrulewidth}{0pt} % Header line thickness
    \renewcommand{\footrulewidth}{0pt} % No footer line
}

% Abstract
\renewcommand{\abstract}[1]{
    \def\SZK@abstract{
        \vspace*{-2 em} % Adjust the space before paragraphs
        \begin{center}
            \bfseries Abstract
        \end{center}
        \vspace*{-0.8em} % Adjust the space after paragraphs
        \setlength{\parindent}{0.5cm} % Indent the first line of text
        \setlength{\parskip}{0pt} % Single spacing        
        #1
    }
}


% Define the \maketitle command with the custom header and randomized title
\makeatletter
\renewcommand{\maketitle}{%
    \begin{titlepage} % Start a new page for the title
        \thispagestyle{titlepage}
        \centering
        \vspace*{\fill}
        {\Huge \randomformat{\@title}\par}
        \vspace{1em}
        {\huge \randomformat{\SZK@undertitle}\par}
        \vspace{2em}
        {\Large \randomformat{by \@author}\par}
        \vspace{2em}
        {\large\SZK@dates.\SZK@year\par}
        \vspace{5em}
        % LOGO
        \begin{minipage}{0.6\textwidth}
                \centering
                \includesvg[width=\textwidth]{IndeResearch.svg}
            \end{minipage}
        \vspace{2em}
        \indent\SZK@abstract\par
        \vspace*{\fill}
    \end{titlepage}
}


%MATH
% Symbols
\let\@forall\forall
\renewcommand{\forall}{\ensuremath{\,\@forall\,}}
\DeclareRobustCommand{\vect}[1]{\vec{#1}}
\newcommand{\indep}{\ensuremath{\perp\!\!\!\perp}}

% Character definitions
\mathchardef\mathmul=\mathcode`*
\mathcode`*=\cdot

% Operators
\DeclareMathOperator{\E}{\mathbb{E}}
\DeclareMathOperator{\prob}{p}
\DeclareMathOperator{\tr}{tr}
\DeclareMathOperator{\diff}{\mathop{}\!{d}}
\DeclareMathOperator{\conv}{\ast}

% Equation spacing
\g@addto@macro\normalsize{%
  \setlength\abovedisplayskip{2.5pt}%
  \setlength\belowdisplayskip{7.5pt}%
  \setlength\abovedisplayshortskip{2.5pt}%
  \setlength\belowdisplayshortskip{7.5pt}%
}

% Set up the page style for fancyhdr
\pagestyle{fancy}

% Define custom header
\fancyhead[L]{{\footnotesize\color{gray}\SZK@copyright}}
\fancyhead[R]{{\footnotesize\color{gray}\SZK@dates.\SZK@year}} % Right-aligned header

% Define custom footer
\fancyfoot[L]{{\footnotesize\color{gray}Archive ID: \SZK@year--\SZK@archive}}
\fancyfoot[C]{}
\fancyfoot[R]{{\footnotesize\color{gray}Page \thepage\ of \pageref{LastPage}}}

\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt} % To remove the footer line

% Footnotes
\renewcommand*{\thefootnote}{\footnotesize\color{important}\Roman{footnote}}

% Define custom fonts
\setmainfont{TeX Gyre Termes}

% Format
\RequirePackage[
    margin=2.5cm,
    top=2.5cm,
    headsep=1cm,
    bottom=3.5cm
]{geometry}

% Section
\newcommand{\sectionfont}{\normalfont}

\titleformat{\section}[block]
  {\normalfont\normalsize\bfseries\sectionfont}
  {\thesection}{1em}{}
  [\titlerule] % Add a rule under the section title

\titleformat{\subsection}[block]
  {\normalfont\normalsize\itshape}
  {\thesubsection}{1em}{}
  [] % No rule after subsection

\titleformat{\subsubsection}[block]
  {\normalfont\normalsize\itshape}
  {\thesubsubsection}{1em}{}
  [] % No rule after subsubsection


% Custom section command with hierarchical numbering style x.y.z
\renewcommand{\thesection}{\arabic{section}} % Section format: 1, 2, 3...
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}} % Subsection format: 1.1, 1.2, 1.3...
\renewcommand{\thesubsubsection}{\thesubsection.\arabic{subsubsection}} % Subsubsection format: 1.1.1, 1.1.2, etc.



% Define custom colors
\definecolor{important}{HTML}{AB2341} % Default headline color (blood red)
\definecolor{slcolor}{HTML}{882B21}   % Custom secondary color (deep red)
\definecolor{tip}{HTML}{1A159B}   % Default Blue
\definecolor{result}{HTML}{6BBB4C}   % Default Blue

% Define a command to set the headline color dynamically
\newcommand{\setimportant}[1]{%
  \renewcommand{\important}{#1}%
}

% Custom section header with dynamic headline color
\newcommand{\importantsection}[1]{%
  \section{\textcolor{important}{#1}}%
}

\newcommand{\tipsection}[1]{%
  \section{\textcolor{tip}{#1}}%
}

\newcommand{\warningsection}[1]{%
  \section{\color{orange}{#1}}%
}

\newcommand{\examplesection}[1]{%
  \section{\itshape\color{blue}{#1}}%
}

\newcommand{\resultsection}[1]{%
  \section{\itshape\textcolor{result}{#1}}%
}

\newcommand{\questionsection}[1]{%
  \section{\itshape\color{gray}{#1}}%
}

% Boxes

\newcommand{\definitionAN}[3]{ % Additional Notes
    \begin{tcolorbox}[title=Definition: #1,
    title filled=false,
    colback=black!3!white,
    colframe=black!75!black]
    #2
    \tcblower
    #3
    \end{tcolorbox}
}

\newcommand{\definition}[2]{
    \begin{tcolorbox}[title=Definition: #1,
    title filled=false,
    colback=black!3!white,
    colframe=black!75!black]
    #2
    \end{tcolorbox}
}

\newcommand{\exercise}[2]{ % Without Solution and Explanation
    \begin{tcolorbox}[title=Exercise: #1,
    title filled=false,
    colback=blue!3!white,
    colframe=blue!50!black]
    #2
    \end{tcolorbox}
}

\newcommand{\exerciseWS}[3]{ % With Solution and Explanation
    \begin{tcolorbox}[title=Exercise: #1,
    title filled=false,
    colback=blue!3!white,
    colframe=blue!50!black]
    #2
    \tcblower
    #3
    \end{tcolorbox}
}

\newcommand{\introduction}[2]{ % With Solution and Explanation
    \begin{tcolorbox}[title=#1,
    title filled=false,
    colback=purple!3!white,
    colframe=purple!75!black]
    #2
    \end{tcolorbox}
}

\newcommand{\summary}[2]{ % With Solution and Explanation
    \begin{tcolorbox}[title=#1,
    title filled=false,
    colback=green!3!white,
    colframe=green!40!black]
    #2
    \end{tcolorbox}
}

% Page layout and column.
\newif\iflayouttoggle
\layouttoggletrue 
% Toggle layout definition
\newcommand{\togglelayout}{%
\clearpage % Ensure site correct layout
  \iflayouttoggle
    \onecolumn
    \layouttogglefalse
  \else
    \twocolumn
    \layouttoggletrue
  \fi
}