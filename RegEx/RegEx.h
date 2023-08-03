/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-CurrentYear, Open Source Modelica Consortium (OSMC),
 * c/o Linköpings universitet, Department of Computer and Information Science,
 * SE-58183 Linköping, Sweden.
 *
 * All rights reserved.
 *
 * THIS PROGRAM IS PROVIDED UNDER THE TERMS OF GPL VERSION 3 LICENSE OR
 * THIS OSMC PUBLIC LICENSE (OSMC-PL) VERSION 1.2.
 * ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES
 * RECIPIENT'S ACCEPTANCE OF THE OSMC PUBLIC LICENSE OR THE GPL VERSION 3,
 * ACCORDING TO RECIPIENTS CHOICE.
 *
 * The OpenModelica software and the Open Source Modelica
 * Consortium (OSMC) Public License (OSMC-PL) are obtained
 * from OSMC, either from the above address,
 * from the URLs: http://www.ida.liu.se/projects/OpenModelica or
 * http://www.openmodelica.org, and in the OpenModelica distribution.
 * GNU version 3 is obtained from: http://www.gnu.org/copyleft/gpl.html.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without
 * even the implied warranty of  MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE, EXCEPT AS EXPRESSLY SET FORTH
 * IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE CONDITIONS OF OSMC-PL.
 *
 * See the full OSMC Public License conditions for more details.
 *
 */

#ifndef _OMS_REGEX_H_
#define _OMS_REGEX_H_

#include <regex>

// adrpo: crap regex handling
#if __cplusplus >= 201103L &&                             \
    (!defined(__GLIBCXX__) || (__cplusplus >= 201402L) || \
        (defined(_GLIBCXX_REGEX_DFS_QUANTIFIERS_LIMIT) || \
         defined(_GLIBCXX_REGEX_STATE_LIMIT)           || \
             (defined(_GLIBCXX_RELEASE)                && \
             _GLIBCXX_RELEASE > 4)))

#define OMS_GOOD_REGEX 1

#else /* bad regex, filter by MSVC */

#if defined(_MSC_VER)
#define OMS_GOOD_REGEX 1
#else /* surely bad regex */
#define OMS_GOOD_REGEX 0
#endif

#endif

#if OMS_GOOD_REGEX
#define oms_regex std::regex
#define oms_regex_match std::regex_match

#else

// We probably do not need to depend on Boost just for regex anymore.
// If the standard regex library is not deemed suitable (unlikely)
// by the checks above, then just report and error so we can take
// another look at this regex issue.
#error "The regex library is not usable by OMSimulator. Please report an issue at https://github.com/OpenModelica/OMSimulator/issues/new?assignees=&labels=&projects=&template=bug_report.md"

// #include <boost/regex.hpp>
// #define oms_regex boost::regex
// #define oms_regex_match boost::regex_match


#endif

#endif // #ifndef _OMS_REGEX_H_
